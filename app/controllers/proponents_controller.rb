class ProponentsController < ApplicationController
  before_action :set_items, only: %i[show edit update destroy]
  include ApplicationHelper
  # GET /proponentes or /proponentes.json
  def index
    params_index = params.permit!
    params_to_search = params_index[:q] || {}


     @rows = params[:page] || 1

    @q = model_name.ransack(params_to_search)

    @items = @q.result(distinct: true).accessible_by(current_ability).paginate(per_page: 5, page: @rows).order(id: :desc)

  end

  # GET /proponentes/1 or /proponentes/1.json
  def show; end

  # GET /proponentes/new
  def new
    @item = Proponent.new
  end

  # GET /proponentes/1/edit
  def edit; end

  # POST /proponentes or /proponentes.json
  def create
    @item = Proponent.new(proponent_params)
    @item.discount_inss = calcular_inss(proponent_params[:wage].to_f)
    respond_to do |format|
      if @item.save
        format.html { redirect_to proponent_url(@item), notice: "Proponente was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proponentes/1 or /proponentes/1.json
  def update

    respond_to do |format|
      proponent_params.merge!(discount_inss: calcular_inss(proponent_params[:wage].to_f))
      if @item.update(proponent_params)

        format.html { redirect_to proponent_url(@item), notice: 'Proponente was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proponentes/1 or /proponentes/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to proponent_url, notice: "Proponente was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def calculate_inss
    wage = params[:wage].to_f
    discount_inss = calcular_inss(wage)
    render json: { discount_inss: discount_inss.round(2) }
  end



  private

  def calcular_inss(wage)

    tracks = [
      { limit: 1045.00, aliquot: 0.075 },
      { limit: 2089.60, aliquot: 0.09 },
      { limit: 3134.40, aliquot: 0.12 },
      { limit: 6101.06, aliquot: 0.14 }
    ]

    desconto = 0

    tracks.each do |track|
      if wage > track[:limit]
        desconto += (track[:limit] - (track[:previous_limit] || 0)) * track[:aliquot]
      else
        desconto += (wage - (track[:previous_limit] || 0)) * track[:aliquot]
        break
      end
      track[:previous_limit] = track[:limit]
    end
    desconto
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_items
    if params[:id] == "calculate_inss"
      calculate_inss
    else
      @item = model_name.find(params[:id])
    end

  end
  def model_name
    Proponent
  end

  # Only allow a list of trusted parameters through.
  def proponent_params
    params.require(:proponent).permit(:name,
                                      :cpf,
                                      :birthday,
                                      :street,
                                      :number,
                                      :district,
                                      :city,
                                      :state,
                                      :cep,
                                      :phone,
                                      :wage,
                                      :discount_inss)
  end
end
