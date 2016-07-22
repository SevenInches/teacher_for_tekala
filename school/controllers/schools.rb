Tekala::School.controllers :v1, :schools  do

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end

  end

  get :teachers, :map => '/v1/teachers', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @teachers = Teacher.first
      @total    = 1
    else
      @teachers = @school.teachers.all(:open => 1)
      @total    = @teachers.count
      @teachers = @teachers.paginate(:per_page => 20, :page => params[:page])
    end
    render 'teachers'
  end

  get :fields, :map => '/v1/fields', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @fields = TrainField.first
      @total    = 1
    else
      @fields = @school.train_fields.all(:open => 1)
      @total  = @fields.count
      @fields = @fields.paginate(:per_page => 20, :page => params[:page])
    end
    render 'fields'
  end

  get :users, :map => '/v1/users', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @users    = User.first
      @total    = 1
    else
      @users = @school.users
      @total = @users.count
      @users = @users.paginate(:per_page => 20, :page => params[:page])
    end
    render 'users'
  end

end