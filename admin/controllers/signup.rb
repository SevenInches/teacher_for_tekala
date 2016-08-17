Tekala::Admin.controllers :signup do

  get :index do
    @signup = Signup.all(:school_id => session[:school_no])
    p @signup
    render "signup/index"
  end

end
