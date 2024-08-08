class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def self.between_dates(md, di, df, param = 'created_at')
    return if param == 'all'

    start_ = di.present? ? Time.parse(di) : Time.now
    end_ = df.present? ? Time.parse(df) : Time.now
    if md.present?
      where("#{md}": { "#{param}": start_.beginning_of_day..end_.end_of_day})
    else
      where("#{param}": start_.beginning_of_day..end_.end_of_day)
    end
    # between_times(start_.beginning_of_day..end_.end_of_day, field: :date_created)
  end
end
