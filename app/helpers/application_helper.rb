module ApplicationHelper
  include ActiveLinkToHelper
  include TemplateNavHelper


  def asset_exist?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end

  # Breadcumb for every page
  def breadcrumb(new = false)
    plural = %w(index).include?(action_name_label) ? 'other' : 'one'
    title = t("controllers.#{controller_name}.#{plural}", default: "action.#{action_name_label}")
    action = t("views.#{controller_name}.action.#{action_name_label}", default: t("action.#{action_name_label}"))
    # title "#{title} | #{action}"

    content_tag :div, class: 'd-flex justify-content-space-betwee' do
      left = content_tag :div do
        div = content_tag(:ol, class: 'breadcrumb breadcrumb px-2 pb-2') do
          content = content_tag :li, class: 'breadcrumb-item' do
            link_to 'Página Inicial', root_path
          end
          content += content_tag :li, class: 'breadcrumb-item' do
            link_to title, { controller: "#{controller_name}", action: 'index' }
          end
          content + content_tag(:li, class: 'breadcrumb-item active') do
            action
          end
        end
        raw(title + div)
      end
      if new
        left += content_tag(:div, class: 'ml-auto') do
          content_tag :div, class: 'btn-group' do
            link_to 'Novo', { action: 'new' }, class: 'btn btn-secondary'
          end
        end
      end
      left
    end.html_safe
  end
  def notification_errors
    content_tag :script do
      content = ''
      @item.errors.messages.each do |key, msg|
        next if msg.blank?
        content += "toastr['error']('#{t("simple_form.labels.#{@item.model_name.param_key}.#{key}")} #{msg.first}', 'Ooops!');"
      end
      content.html_safe
    end.html_safe
  end
  def notification_flash
    content_tag :script do
      content = ''
      flash.each do |key, value|
        key = bootstrap_alert(key)
        if value.is_a? Array
          value = "'#{value[1]}', '#{value[0]}'"
        else
          value = "'#{value}', '#{t("flash.actions.#{key}")}'"
        end
        content += "toastr['#{key}'](#{value});"
      end
      content.html_safe
    end.html_safe
  end

  def bootstrap_alert(key)
    case key
    when 'alert'
      'warning'
    when 'notice'
      'success'
    when 'error'
      'danger'
    else
      key
    end
  end

  # Override table for attributes
  def index_table_for(collection, options = { actions: %w(show edit destroy) }, &block)
    options[:class] = 'table table-hover'
    inner_table = if collection.count > 0
                    content_tag(:div, class: 'table-responsive') do
                      t = EasyTable::TableBuilder.new(collection, self, options)
                      block.yield(t) if block_given?
                      actions = options.delete(:actions)
                      if actions
                        t.column t('action.other'), class: 'text-right', header_class: 'text-right' do |i|
                          actions_links(actions, i)
                        end
                      end
                      t.build
                    end
                  else
                    content_tag :div, class: 'text-center pb-3 pt-3' do
                      content_tag :p, 'Nenhum resultado', class: 'mb-0'
                    end
                  end
    if options[:wrapper] == false
      content = inner_table
    else
      content = content_tag :div, class: 'card-default card' do
        content_tag :div, class: 'card-body' do
          inner_table
        end
      end
    end

    Rails.logger.debug "Collection class: #{collection.class}"
    Rails.logger.debug "Collection value: #{collection.inspect}"
    #content + collection.blank? ? nil : paginate(collection)
    content + paginate(collection)
  end

  def index_search_form_for(q, options = {}, method_options = { submit: true }, &block)
    search_form_for q, options do |f|
      content_tag :div, class: 'card-default card' do
        content_tag :div, class: 'card-body' do
          content = capture(f, &block)
          if method_options[:submit]
            content += content_tag :hr, nil, class: 'd-print-none'
            content += content_tag :div, class: 'clearfix' do
              f.button :submit, t('action.search'), class: 'btn btn-success float-right'
            end
          end
          content.html_safe
        end
      end
    end
  end

  def partial_simple_form_for(item, options = {}, &block)
    to_submit = options[:submit].nil? ? true : options.delete(:submit)
    options.deep_merge!(html: { 'data-parsley-validate': '' }) unless options[:disable_validation]
    options.deep_merge!(defaults: { disabled: true }) if action_name == 'show'

    # # Avoid STI urls
    # options[:url] ||= if options.key?(:format)
    #                     polymorphic_path(record, format: options.delete(:format))
    #                   else
    #                     polymorphic_path(item.class.base_class, {})
    #                   end

    total = basic_error_messages(item) || ''
    total += simple_form_for(item, options) do |f|
      content = capture(f, &block)
      if to_submit
        content += button_footer(f)
      end
      content.html_safe
    end
    total.html_safe
  end

  def button_footer(f, options = {})
    label = options[:label]
    content = content_tag :hr, nil, class: 'd-print-none'
    raw(content + content_tag(:div, class: 'clearfix', id: 'item_submit') do
      if action_name == 'show'
        link_to t('action.edit'), { action: 'edit' }, class: 'btn btn-success float-right'
      else
        if label.present?
          f.button :submit, label, class: 'btn btn-success float-right'
        else
          f.button :submit, class: 'btn btn-success float-right'
        end
      end
    end)
  end

  # Creates an link by methods passed
  #
  # ==== Options
  # * <tt>l</tt> - This option can be used to pass an array to list the actions that you want
  # * <tt>i</tt> - Have to pass the object to get the id and other necessary things
  #
  # ==== Examples
  #
  # actions_links(['show', 'edit'], User.find.first)

  def actions_links(l, i)
    content_tag :div, class: 'btn-group' do
      l.map do |ll|
        case ll
        when 'show'
          link_to t('action.show'), { action: 'show', id: i.id }, class: 'btn btn-secondary btn-sm'
        when 'download'
          link_to t('action.download'), { action: 'show', format: 'pdf', id: i.id }, target: '_blank', class: 'btn btn-secondary btn-sm'
        when 'edit'
          link_to t('action.edit'), { action: 'edit', id: i.id }, class: 'btn btn-secondary btn-sm'
        when 'details'
          link_to t('action.details'), { action: 'edit', id: i.id }, class: 'btn btn-secondary btn-sm'
        when 'destroy'
          link_to t('action.destroy'), { action: 'destroy', id: i.id }, method: :delete, data: { confirm: 'Você tem certeza?' }, class: 'btn btn-danger btn-sm'
        when 'block'
          if i.locked_at.present?
            link_to t('action.unblock'), { action: 'unblock', id: i.id }, method: :patch, data: { confirm: 'Você tem certeza?' }, class: 'btn btn-success btn-sm'
          else
            link_to t('action.block'), { action: 'block', id: i.id }, method: :patch, data: { confirm: 'Você tem certeza?' }, class: 'btn btn-danger btn-sm'
          end
        when 'manage'
          link_to t('action.manage'), { action: 'manage', id: i.tenant_name }, class: 'btn btn-secondary btn-sm'
        end
      end.join.html_safe
    end

  end

  def proposal_info(title, &block)
    return if capture(&block).blank?
    content = content_tag :p, title, class: 'lead bb'
    raw(content + content_tag(:form, class: 'form-horizontal') do
      capture(&block)
    end)
  end

  def basic_error_messages(item = @item)
    return if item.try(:errors).nil? || item.errors.empty?

    messages = ''
    item.errors.full_messages.each do |msg|
      messages += build_notification(msg)
    end

    messages.html_safe
  end

  def build_notification(msg, type = 'danger')
    content_tag :div, class: "alert alert-#{type} alert-dismissible fade show", role: 'alert' do
      content = button_tag class: 'close', 'data-dismiss': 'alert', 'aria-label': 'Close' do
        content_tag :span, '×', 'aria-hidden': 'true'
      end
      content + msg
    end
  end

  # TODO: apply this for helpers and controllers
  def action_name_label
    case action_name
    when 'create'
      'new'
    when 'update'
      'edit'
    else
      action_name
    end
  end

  # TODO: REMOVE THIIIS
  def get_status(s)
    case s
    when 'simulation'
      'badge-primary'
    when 'approved'
      'badge-success'
    when 'pre-approved'
      'badge-test'
    when 'reproved', 'expired'
      'badge-danger'
    when 'resend_documents', 'under_analysis', 'send_documents', 'company_analysing','awaiting_contract','pendency', 'waiting_confirmation'
      'badge-warning'
    when 'REPASSADO_PARA_EMPRESA', 'PRE_APROVADO'
      'badge-success'
    when 'hired', 'fill_data'
      'badge-info'
    when 'released'
      'badge-purple'
    else
      'badge'
    end
  end

  def detail_item(name, value)
    return if value.blank?

    content_tag(:div, class: 'form-group row') do
      safe_concat content_tag(:div, t("views.#{params[:controller]}.#{name}"), class: 'col-md-4')
      safe_concat(content_tag(:div, class: 'col-md-8') do
        content_tag :strong, value.to_s.html_safe
      end)
    end
  end
  def detail_item_version(name, value)
    return if value.blank?

    content_tag(:div, class: 'form-group row') do
      safe_concat content_tag(:div, t("views.#{params[:controller]}.#{name}"), class: 'col-md-4')
      safe_concat(content_tag(:div, class: 'col-md-8') do
        content_tag :strong, ( value.to_s).html_safe

      end)
    end
  end

  def link_to_back(name = nil, html_options = nil, &block)
    session_url = session["#{params[:controller]}_results".to_sym]
    session_url.present? ? session_url : :back
    link_to(name, session_url, html_options, &block)
  end

  # Values helpers
  def currency_to_number(c)
    c.to_s.gsub(/[^\d,]/,'').gsub(/,/,'.').to_f
  end

  def number_to_tax(n)
    if n.to_i == 0 && !n.nil?
      number_to_percentage(n*100, precision: 2) if n.present?
    else
      number_to_percentage(n, precision: 2) if n.present?
    end

  end

  def tabs_list(*args)
    args.select { |i| @flux.include?(i[:code]) }.each_with_index do |t, idx|
      idx += 1
      if  session['current_tenant'] == 'sicoob_metropolitano'
        concat(tab_item(idx, t[:label], t[:description], @proposal.step == t[:code], width: '15.5%' ))
      else
        concat(tab_item(idx, t[:label], t[:description], @proposal.step == t[:code], width: t[:width] || '16%'))
      end

    end
  end

  def tab_item(number, label, description, current = '', options = {})
    options[:width] = '20%' if options[:width].blank?
    current = 'current' if current.present?
    content_tag(:li, class: "first #{current}", style: "width: #{options[:width]}") do
      link_to '#' ,  style: "cursor: initial" do
        safe_concat(content_tag(:span, class: 'number') do
          "#{number}. "
        end)
        safe_concat(label)
        safe_concat(content_tag(:br))
        safe_concat(content_tag(:small, description))
      end
    end
  end

  def suiv_datum_item(value, t)
    content = content_tag(:dt, t("views.proposal_simulations.edit.suiv.#{t}"), class: 'col-sm-12 col-lg-4')
    raw(content + content_tag(:dd, value, class: 'col-sm-12 col-lg-8'))
  end

  def prev_step
    return if @flux.nil?

    index = @flux.index(@proposal.step)
    index = 0 if index.nil?
    return if  index.zero?

    @flux[index-1]
  end
  def next_step
    return if @flux.nil?

    index = @flux.index(@proposal.step)
    index = 0 if index.nil?
    return if  index.zero?

    @flux[index]
  end
  def info_list(options = {}, &block)
    options[:class] ||= 'row justify-content-md-center mb-4'
    content_tag :div, class: options[:class], style: 'border-bottom: 1px solid #e4eaec;' do
      capture(options[:wrapper_options] ||= {}, &block)
    end.html_safe
  end

  def item_info_list(*args, &block)
    if block_given?
      i, title, options = args[0], args[1], args[2]
    else
      i, title, content, options = args[0], args[1], args[2], args[3]
    end
    i[:wrapper_class] ||= ' text-center mb-4'
    klass = (options[:class] || '') + i[:wrapper_class]
    content_tag :div, class: klass do
      concat(content_tag(:h4, title))
      if block_given?
        concat(capture(&block))
      else
        concat(content_tag(:b, content, options.try(:[], :b_options)))
      end
    end
  end

  def item_document(object, item, options = {})
    # send documents
    if %w[resend_documents].include?(object.object['status'])
      options[:required] = false
    else
      options[:required] ||= false
    end

    content_tag :fieldset do
      content_tag :div, class: 'form-group row' do
        safe_concat(content_tag(:label, options[:label], class: 'col-md-2 col-form-label'))
        safe_concat(content_tag(:div, class: 'col-md-auto pr-0') do
          object.input item.to_sym, as: :file, accept:'image/jpeg, image/png, document/pdf' ,capture:'user',input_html: { class: 'filestyle', data: { classbutton: 'btn btn-secondary', classinput: 'form-control inline', text: 'Selecionar', icon: '<span class="fa fa-upload mr-2"/>' }, direct_upload: false }, label: false, required: options[:required]
        end)
        safe_concat(object.hidden_field "#{item.to_sym}_base64")
        image_src = object.object['documents_data'].present? ?  "data:#{object.object.file_format};base64,#{object.object['documents_data'][item]}"  : nil

        safe_concat(image_tag( image_src, style: 'margin-top: 50px;margin-left: 100px;max-height: 300px; margin-right: 300px;')) if object.object['documents_data'] != nil && image_src.present?
      end
    end
  end
  def remote_file_type(url)
    return nil unless url.present?
    begin
      url = URI.parse(url)
      http = Net::HTTP.get_response(url)
      http.is_a?(Net::HTTPSuccess) ? http['Content-Type'] : nil
    rescue
      nil
    end
  end

  def document_item(path, title)
    get_bucket
    include = 'http://'

    aux_path = path
    aux = URI(path)
    extension = ((path.split('.')[5])[0..4]).split('?')[0]
    if path.split('.').count > 5 && extension !='jpg' &&  extension !='jpeg' &&  extension !='gif' &&  extension !='png' &&  extension !='pdf'
      extension = 'pdf'
    end
    aux_url = @bucket.file aux.path[41...]
    if path[0..6] == 'http://'
      path.sub! 'http://', 'https://'
      include = 'https://'
    else
      include = 'https://'
    end

    # opts = { 'data-input-hidden': name_file, 'data-path': f.object.cpf, 'data-name': name_file, 'data-obj-id': f.object.id, 'data-obj': 'Dynamic' } if obj.present?
    content_tag :div, class: 'document_item' do
      concat(content_tag(:h3, title, class: 'm-0 text-bold mt-2 mb-2'))
      concat(content_tag(:h3, 'Validado', class: 'm-0 text-bold mt-2 mb-2', style: 'color: #63C731;size: 56px'))
      concat(content_tag(:div, class: 'wrapper-img fileinput-preview thumbnail', 'data-label': '') do
        if path.include? include
          if path.present? && path != 'nil'
            # file_type = remote_file_type(path)
            file_type =  aux_url.signed_url(expires: 300) if aux_url.signed_url(expires: 300).present?
            if file_type && extension.downcase != "pdf"
              image_tag(file_type)
            elsif extension.downcase == "pdf"
              concat(content_tag(:div, class: 'navy-bg bg-document-pdf bg-primary p-xs b-r-sm', 'data-pdf': file_type) do
                concat(content_tag(:div, class: 'wrapper-warning-pdf') do
                  concat(content_tag(:span, 'Documento PDF'))
                  concat(content_tag(:i, nil, class: 'fa fa-file-pdf-o'))
                end)
              end)
            else
              concat(content_tag(:div, class: 'navy-bg bg-document-pdf bg-primary p-xs b-r-sm', 'data-pdf': file_type, 'data-type': true) do
                concat(content_tag(:div, class: 'wrapper-warning-pdf') do
                  concat(content_tag(:span, 'Documento PDF'))
                  concat(content_tag(:i, nil, class: 'fa fa-file-pdf-o'))
                end)
              end)
            end
          end
        else
          if %w(jpg jpeg gif png).include?(extension.downcase)
            image_tag(file_type)
          else
            concat(content_tag(:div, class: 'navy-bg bg-document-pdf bg-primary p-xs b-r-sm', 'data-pdf': file_type) do
              concat(content_tag(:div, class: 'wrapper-warning-pdf') do
                concat(content_tag(:span, 'Documento PDF'))
                concat(content_tag(:i, nil, class: 'fa fa-file-pdf-o'))
              end)
            end)
          end
        end
      end)
    end.html_safe
  end

  def format_cnpj(cnpj)
    cnpj = cnpj.to_s

    # Verificar se o CNPJ já está formatado
    if cnpj.match?(/^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$/)
      return cnpj
    end

    # Formatar o CNPJ se tiver 14 dígitos
    if cnpj.length == 14 && cnpj.match?(/^\d+$/)
      "#{cnpj[0..1]}.#{cnpj[2..4]}.#{cnpj[5..7]}/#{cnpj[8..11]}-#{cnpj[12..13]}"
    else
      cnpj
    end
  end
  def format_cpf(cpf)
    cpf = cpf.to_s

    # Verificar se o CPF já está formatado
    if cpf.match?(/^\d{3}\.\d{3}\.\d{3}-\d{2}$/)
      return cpf
    end

    # Formatar o CPF se tiver 11 dígitos
    if cpf.length == 11 && cpf.match?(/^\d+$/)
      "#{cpf[0..2]}.#{cpf[3..5]}.#{cpf[6..8]}-#{cpf[9..10]}"
    else
      cpf
    end
  end
end
