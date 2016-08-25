Tekala::Admin.controllers :roles do
  before do
    if session[:role_user_id]
      @role_user = RoleUser.get session[:role_user_id]
      @school_no = session[:school_no]
      @mobile    = session[:mobile]
      @title = '人员管理'
    elsif !params['demo'].present?
      redirect_to(url(:edit_psd, :unlogin))
    end
  end

  get :index do
    @users = RoleUser.all()
    @users = @users.all(:role_id => params[:role_id]) if params[:role_id].present?
    @users = @users.paginate(:page => params[:page],:per_page => 20)
    @users = @users.reverse
    render "roles/index"
  end

  post :create do
    @user = RoleUser.new(params[:user])
    @user.password = '123456'
    # @user =
    if @user.save
      flash[:success] = pat(:create_success, :model => 'RoleUser')
      redirect(url(:roles, :index))
    else
      render 'roles/index'
    end
  end

  get :destroy, :with => :id do
    push = RoleUser.get(params[:id])
    if push
      if push.destroy
        flash[:success] = pat(:delete_success, :model => 'RoleUser', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'RoleUser')
      end
      redirect url(:roles, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'RoleUser', :id => "#{params[:id]}")
      halt 404
    end
  end

  post :change do
    role_user = @role_user.change_other_psd(params[:id].to_i,params[:new_password], params[:confirm_password])
    if role_user
      flash[:success] = pat(:update_success, :model => 'RoleUser', :id =>  "#{params[:id]}")
    else
      flash.now[:error] = pat(:update_error, :model => 'RoleUser')
    end
    redirect_to(url(:roles, :index))
  end

end
