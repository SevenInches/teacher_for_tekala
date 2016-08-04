Tekala::School.controllers :v1, :roles  do

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :roles, :map => '/v1/roles', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @roles    = Role.first
      @total    = 1
    else
      @roles  = @school.roles
      @total  = @roles.count
      @roles  = @roles.paginate(:per_page => 20, :page => params[:page])
    end
    render 'roles'
  end

  get :role, :map => '/v1/roles/:id', :provides => [:json] do
    @users  = RoleUser.all(:role_id => params[:id])
    @total  = @users.count
    @users  = @users.paginate(:per_page => 20, :page => params[:page])
    render 'role_users'
  end

  post :roles, :map => '/v1/roles', :provides => [:json] do
    if params[:name].present?
      @role = Role.new(:name => params[:name], :school_id => @school.id)
      if @role.save
        {:status => :success, :name => @role.name, :id => @role.id}.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :cars, :map => '/v1/cars', :provides => [:json] do
    if params[:id].present?
      @role = Role.get(params[:id])
      @role.name  =  params[:name]  if params[:name].present?
      if @role.save
        {:status => :success, :name => @role.name, :id => @role.id}.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  post :role, :map => '/v1/roles/:id', :provides => [:json] do
    if params[:name].present?
      @role = Role.get(params[:id])
      if @role.present?
        @user = RoleUser.new(:role_id => @role.id, :name=> params[:name])
        if @user.save
          {:status => :success, :name => @user.name, :id => @user.id}.to_json
        end
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  delete :role_user, :map => '/v1/role_users/:id', :provides => [:json] do
    current = RoleUser.get(params[:id])
    if current.destroy
      {:status => :success, :name => "管理员:#{current.name}删除成功"}.to_json
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end
end