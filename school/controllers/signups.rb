Tekala::School.controllers :v1, :signups  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :signups, :map => '/v1/signups', :provides => [:json] do
    # if params['demo'].present?
    #   @demo     = params['demo']
    #   @signups  = User.first
    #   @total    = 1
    # else
      @users = @school.users
      @user_ids = Signup.all(:status => 1, :school_id => session[:school_id]).aggregate(:user_id)
      if params[:pay].present?
        @users  = @users.all(:id.not => @user_ids)
      else
        @users  = @users.all(:id => @user_ids)
      end
      @users = @users.all(:origin => params[:origin])   if params[:origin].present?
      @users = @users.all(:local => params[:local])     if params[:local].present?
      if params[:key].present?
        if params[:key].to_i > 0
          @users = @users.all(:id => params[:key])
        else
          @users = @users.all(:name => params[:key])
        end
      end
      @total = @users.count
      @users = @users.paginate(:per_page => 20, :page => params[:page])
    #end
    render 'signups'
  end

  get :signup, :map => '/v1/signups/:id', :provides => [:json] do
    @user = User.get(params[:id])
    render 'signup'
  end

  post :signups, :map => '/v1/signups', :provides => [:json] do
    if params[:name].present? && params[:product].present?
      @user = User.new(:school_id =>session[:school_id])
      @user.name         = params[:name]          if params[:name].present?
      @user.mobile       = params[:mobile]        if params[:mobile].present?
      @user.sex          = params[:sex]           if params[:sex].present?
      @user.id_card      = params[:id_card]       if params[:id_card].present?
      @user.address      = params[:address]       if params[:address].present?
      @user.origin       = params[:origin]        if params[:origin].present?
      @user.branch_id    = params[:branch]        if params[:branch].present?
      @user.manager_no   = params[:manager_no]    if params[:manager_no].present?
      @user.operation_no = params[:operation_no]  if params[:operation_no].present?
      @user.apply_type   = params[:apply_type]    if params[:apply_type].present?
      @user.local        = params[:local]         if params[:local].present?
      @user.exam_type    = params[:exam_type]     if params[:exam_type].present?
      @user.status_flag  =  1                     if params[:pay].present?
      @user.password     = '123456'

      if @user.save
        signup = Signup.new(:school_id =>session[:school_id], :user_id => @user.id)
        signup.product_id   = params[:product]
        signup.amount       = params[:amount].present? ? params[:amount] : Product.get(params[:amount]).price
        signup.exam_type    = params[:exam_type]     if params[:exam_type].present?
        signup.status       =  2                     if params[:pay].present?
        if signup.save
          render 'signup'
        end
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :signups, :map => '/v1/signups', :provides => [:json] do
    if params[:id].present?
      @user = User.get(params[:id])
      @user.name         = params[:name]          if params[:name].present?
      @user.mobile       = params[:mobile]        if params[:mobile].present?
      @user.sex          = params[:sex]           if params[:sex].present?
      @user.id_card      = params[:id_card]       if params[:id_card].present?
      @user.address      = params[:address]       if params[:address].present?
      @user.origin       = params[:origin]        if params[:origin].present?
      @user.branch_id    = params[:branch]        if params[:branch].present?
      @user.manager_no   = params[:manager_no]    if params[:manager_no].present?
      @user.operation_no = params[:operation_no]  if params[:operation_no].present?
      @user.apply_type   = params[:apply_type]    if params[:apply_type].present?
      @user.local        = params[:local]         if params[:local].present?

      if @user.save
        signup  =  @user.signup
        signup.product_id   = params[:product]
        signup.amount       = params[:amount]        if params[:amount].present?
        signup.status       = 2                      if params[:status].present?
        if signup.save
          render 'signup'
        end
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end
end