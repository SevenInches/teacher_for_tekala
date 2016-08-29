Tekala::Admin.controllers :roles do
  before do
    if session[:role_user_id]
      @role_user = Role.get session[:role_user_id]
      @school_no = session[:school_no]
      @mobile    = session[:mobile]
      @title = '人员管理'
    elsif !params['demo'].present?
      redirect_to(url(:edit_psd, :unlogin))
    end
  end

  get :index do
    @users = Role.all()
    @users = @users.all(:role_id => params[:role_id]) if params[:role_id].present?
    @users = @users.paginate(:page => params[:page],:per_page => 20)
    @users = @users.reverse
    render "roles/index"
  end

  post :create do
    @user = Role.new(params[:user])
    @user.school_id = session[:school_no]
    @user.password  = '123456'
    p @user
    if @user.save
      flash[:success] = pat(:create_success, :model => 'Role')
    else
      flash[:error] = pat(:create_error, :model => 'Role')
    end
    redirect(url(:roles, :index))
  end

  get :destroy, :with => :id do
    push = Role.get(params[:id])
    if push
      if push.destroy
        flash[:success] = pat(:delete_success, :model => 'Role', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'Role')
      end
      redirect url(:roles, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'Role', :id => "#{params[:id]}")
      halt 404
    end
  end

  post :change do
    role_user = Role.change_other_psd(params[:user_id].to_i,params[:new_password], params[:confirm_password])
    if role_user
      flash[:success] = pat(:update_success, :model => 'Role', :id =>  "#{params[:id]}")
    else
      flash.now[:error] = pat(:update_error, :model => 'Role')
    end
    redirect_to(url(:roles, :index))
  end

end
