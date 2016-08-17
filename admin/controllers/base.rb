Tekala::Admin.controllers :base do

  get :index, :map => "/" do
    @school  = School.first(:school_no => session[:school_no])
    @user    = RoleUser.first(:id => session[:role_user_id])
    # @car   = Car.first(:school_id => session[:school_no])
    @student = Student.all(:shop_id => session[:school_no])
    render "index/index"
  end

end
