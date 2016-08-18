Tekala::Admin.controllers :base do

  get :index, :map => "/" do
    @school  = School.first(:school_no => session[:school_no])
    @user    = RoleUser.first(:id => session[:role_user_id])
    @car     = Car.all(:school_id => session[:school_id])
    @student = Student.all(:shop_id => session[:school_id])
    @teacher = Teacher.all(:school_id => session[:school_id])
    @shop    = Shop.all(:school_id => session[:school_id])
    @order   = Order.all(:school_id => session[:school_no])
    render "index/index"
  end

end
