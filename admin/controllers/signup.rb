Tekala::Admin.controllers :signup do
  get :index do
    @title  = '报名管理'
    @signup = Signup.all(:school_id => session[:school_id])
    @signup = @signup.paginate(:page => params[:page],:per_page => 5)
    render "signup/index"
  end
end
