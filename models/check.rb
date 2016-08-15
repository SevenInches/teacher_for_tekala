class Check
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :car_id, Integer
  property :check_end, Date
  property :year_check_end, Date
  property :season_check_end, Date
  property :second_check_end, Date

  belongs_to :car

  def not_handle
    handle_status.count>0 ? true : false
  end

  def handle_status
    status = []
    if check_end.present? && check_end <= (Date.today + 3.month)
      status << 1
    end
    if year_check_end.present? && year_check_end <= (Date.today + 3.month)
      status << 2
    end
    if season_check_end.present? && season_check_end <= (Date.today + 1.month)
      status << 3
    end
    if second_check_end.present? && second_check_end <= (Date.today + 3.month)
      status << 4
    end
    status
  end

  def handle_status_demo
    '未处理状态: 1=>未缴保,2=>未年审,3=>未季审,4=>未维护'
  end
end
