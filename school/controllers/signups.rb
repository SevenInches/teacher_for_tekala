Tekala::School.controllers :v1, :signups  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :signups, :map => '/v1/signups', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      signup  = Signup.first
      if signup.present?
        @users = User.all(:id => signup.user_id)
      end
      @total    = 1
    else
      @users = @school.users
      @user_ids = Signup.all(:status => 1, :school_id => session[:school_id]).aggregate(:user_id)
      if params[:pay].present?
        @users  = @users.all(:id.not => @user_ids)
      else
        @users  = @users.all(:id => @user_ids)
      end

      if params[:origin].present?
        origins = params[:origin].split(/,/)
        @users  = @users.all(:origin => origins)
      end

      if params[:pay_type].present?
        types  = params[:pay_type].split(/,/)
        @users = @users.all(:pay_type => types)
      end

      if params[:product].present?
        products = params[:product].split(/,/)
        @users   = @users.all(:product_id => products)
      end

      if params[:sex].present?
        sexes  = params[:sex].split(/,/)
        @users = @users.all(:sex => sexes)
      end

      if params[:apply_type].present?
        applys  = params[:apply_type].split(/,/)
        @users = @users.all(:apply_type => applys)
      end

      if params[:local].present?
        locals  = params[:local].split(/,/)
        @users = @users.all(:local => locals)
      end

      @users = @users.all(:mobile => params[:mobile])     if params[:mobile].present?
      @users = @users.all(:name => params[:name])         if params[:name].present?
      @total = @users.count
      @users = @users.paginate(:per_page => 20, :page => params[:page])
    end
    render 'signups'
  end

  get :signup, :map => '/v1/signups/:id', :provides => [:json] do
    @user = User.get(params[:id])
    render 'signup'
  end

  post :signups, :map => '/v1/signups', :provides => [:json] do
    if params[:name].present? && params[:product].present?
      @user = User.new(:school_id =>session[:school_id])
      @user.name         =  params[:name]          if params[:name].present?
      @user.mobile       =  params[:mobile]        if params[:mobile].present?
      @user.sex          =  params[:sex]           if params[:sex].present?
      @user.id_card      =  params[:id_card]       if params[:id_card].present?
      @user.address      =  params[:address]       if params[:address].present?
      @user.origin       =  params[:origin]        if params[:origin].present?
      @user.branch_id    =  params[:branch]        if params[:branch].present?
      @user.manager_no   =  params[:manager_no]    if params[:manager_no].present?
      @user.operation_no =  params[:operation_no]  if params[:operation_no].present?
      @user.apply_type   =  params[:apply_type]    if params[:apply_type].present?
      @user.local        =  params[:local]         if params[:local].present?
      @user.exam_type    =  params[:exam_type]     if params[:exam_type].present?
      @user.pay_type     =  params[:pay_type]      if params[:pay_type].present?
      @user.status_flag  =  1                      if params[:pay].present?
      @user.product_id   =  params[:product]
      @user.password     =  '123456'
      @user.save

      signup = Signup.new(:school_id =>session[:school_id], :user_id => @user.id)
      signup.product_id  =  params[:product]
      signup.amount      =  params[:amount].present? ? params[:amount] : Product.get(params[:amount]).price
      signup.exam_type   =  params[:exam_type]     if params[:exam_type].present?
      signup.status      =  2                      if params[:pay].present?
      if signup.save
        render 'signup'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :signups, :map => '/v1/signups', :provides => [:json] do
    if params[:id].present?
      @user = User.get(params[:id])
      @user.name         =  params[:name]          if params[:name].present?
      @user.mobile       =  params[:mobile]        if params[:mobile].present?
      @user.sex          =  params[:sex]           if params[:sex].present?
      @user.id_card      =  params[:id_card]       if params[:id_card].present?
      @user.address      =  params[:address]       if params[:address].present?
      @user.origin       =  params[:origin]        if params[:origin].present?
      @user.branch_id    =  params[:branch]        if params[:branch].present?
      @user.manager_no   =  params[:manager_no]    if params[:manager_no].present?
      @user.operation_no =  params[:operation_no]  if params[:operation_no].present?
      @user.apply_type   =  params[:apply_type]    if params[:apply_type].present?
      @user.local        =  params[:local]         if params[:local].present?
      @user.pay_type     =  params[:pay_type]      if params[:pay_type].present?

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