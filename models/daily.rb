class Daily
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :consult, Integer, :default => 0
  property :enroll,  Integer, :default => 0
  property :people,  Integer, :default => 0
  property :time,    Integer, :default => 0
  property :exam_one, Integer, :default => 0
  property :one_pass, Integer, :default => 0
  property :exam_two, Integer, :default => 0
  property :two_pass, Integer, :default => 0
  property :exam_three, Integer, :default => 0
  property :three_pass, Integer, :default => 0
  property :exam_four, Integer, :default => 0
  property :four_pass, Integer, :default => 0
  property :incomes, String
  property :refund, Integer, :default => 0
  property :refund_money, String
  property :school_id, Integer
  property :created_at, DateTime

  belongs_to :school

  def self.daily_report
    schools = School.all(:school_no => '008024')

    schools.each do |school|
      today = Date.today .. Date.tomorrow
      school_daily = Daily.new(:school_id => school.id)
      school_daily.consult  =  school.shops.consultants.all(:created_at => today).count

      signups  =  school.signups.all(:pay_at => today, :status => 2)
      school_daily.enroll   =  signups.count
      school_daily.incomes  =  signups.sum(:amount)

      enroll_rate  = (school_daily.consult!=0) ? (school_daily.enroll/school_daily.consult)*100.range(2) : 0

      orders = school.users.orders.all(:book_time => today, :status => [3, 4])
      school_daily.people   =  orders.count
      school_daily.time     =  orders.sum(:quantity)

      exam_one = school.users.cycles.all(:date => today, :level=> [10, 11])
      school_daily.exam_one     =  exam_one.count
      school_daily.one_pass     =  exam_one.all(:result => 1).count
      one_rate  = (school_daily.exam_one!=0) ? (school_daily.one_pass/school_daily.exam_one)*100.range(2) : 0

      exam_two = school.users.cycles.all(:date => today, :level=> [20, 21])
      school_daily.exam_two     =  exam_two.count
      school_daily.two_pass     =  exam_two.all(:result => 1).count
      two_rate  = (school_daily.exam_two!=0) ? (school_daily.two_pass/school_daily.exam_two)*100.range(2) : 0

      exam_three = school.users.cycles.all(:date => today, :level=> [30, 31])
      school_daily.exam_three    =  exam_three.count
      school_daily.three_pass    =  exam_three.all(:result => 1).count
      three_rate  = (school_daily.exam_three!=0) ? (school_daily.three_pass/school_daily.exam_three)*100.range(2) : 0

      exam_four  = school.users.cycles.all(:date => today, :level=> [40, 41])
      school_daily.exam_four     =  exam_four.count
      school_daily.four_pass     =  exam_four.all(:result => 1).count
      four_rate  = (school_daily.exam_four!=0) ? (school_daily.four_pass/school_daily.exam_four)*100.range(2) : 0

      refunds  =  school.signups.all(:refund_at => today, :status => 4)
      school_daily.refund        =  refunds.count
      school_daily.refund_money  =  refunds.sum(:amount)

      school_daily.created_at    = Date.today

      if school_daily.save
        card = MessageCard.new(:school_id => school.id, :type => 2)
        card.content    = school.name.present? ?  "#{school.name}今日速报" :  "日报"
        card.created_at = Time.now
        card.message_id = school_daily.id
        if card.save
          content = "<div>一、招生</div>
              <div>  今天咨询#{school_daily.consult}人，招生#{school_daily.enroll}人，转化率#{enroll_rate}%</div>
              <div>二、学车考试</div>
              <div>  今天练车学员#{school_daily.people}人，总共#{school_daily.time}学时。</div>
              <div>  科目一考试#{school_daily.exam_one}人，通过#{school_daily.one_pass}人，通过率#{one_rate}%</div>
              <div>  科目二考试#{school_daily.exam_two}人，通过#{school_daily.two_pass}人，通过率#{two_rate}%</div>
              <div>  科目三考试#{school_daily.exam_three}人，通过#{school_daily.three_pass}人，通过率#{three_rate}%</div>
              <div>  科目四考试#{school_daily.exam_four}人，通过#{school_daily.four_pass}人，通过率#{four_rate}%</div>
              <div>三、营收</div>
              <div>  营业收入#{school_daily.incomes}元，退款人数#{school_daily.refund}人，#{school_daily.refund_money}元</div>"

          JPush.send_daily(school.id, content)
        end
      end
    end

  end

end