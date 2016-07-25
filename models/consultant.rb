class Consultant
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :sex, Integer, :default => 0
  property :age, Integer
  property :mobile, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :shop_id, Integer

  belongs_to :shop

  def self.user_num
    month_beginning = Date.strptime(Time.now.beginning_of_month.to_s,'%Y-%m-%d')
    this_month = month_beginning  .. Date.tomorrow
    Consultant.count(:created_at => this_month)
  end

  def signup_amount
    month_beginning = Date.strptime(Time.now.beginning_of_month.to_s,'%Y-%m-%d')
    this_month = month_beginning  .. Date.tomorrow
    amount = signups.all(:created_at => this_month, :status => 2).sum(:amount)
    amount.present? ? amount.round(2) : 0
  end

  def signup_amount_demo
    '本月营收'
  end

  def user_num_demo
    '本月招生'
  end

end