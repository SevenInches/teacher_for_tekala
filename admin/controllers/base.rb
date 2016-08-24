Tekala::Admin.controllers :base do

  before do
    if session[:role_user_id]
      $role_user = RoleUser.get session[:role_user_id]
      $school_no = session[:school_no]
      $mobile    = session[:mobile]
      $school    = School.first(:school_no => @school_no)
    elsif !params['demo'].present?
      redirect_to(url(:edit_psd, :unlogin))
    end
  end

  get :index, :map => "/" do
    @school  = $school
    @user    = RoleUser.first(:id => session[:role_user_id])
    @car     = Car.all(:school_id => session[:school_id])
    @student = Student.all(:shop_id => session[:school_id])
    @teacher = Teacher.all(:school_id => session[:school_id])
    @shop    = Shop.all(:school_id => session[:school_id])
    @order   = Order.all(:school_id => session[:school_no])

    month_beginning = Date.strptime(Time.now.beginning_of_month.to_s,'%Y-%m-%d')

    this_month = month_beginning  .. Date.tomorrow
    @signups = $school.signups.all(:pay_at => this_month, :status => 2).count
    @amounts = $school.signups.all(:pay_at => this_month, :status => 2).sum(:amount)
    @amounts = @amounts ? @amounts : '0'

    today = Date.today .. Date.tomorrow
    @orders = $school.users.orders.all(:book_time => today, :status => [3, 4]).count
    @exams  = $school.users.cycles.all(:date => today).count

    render "index/index"
  end

end
