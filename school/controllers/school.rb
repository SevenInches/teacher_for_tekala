Tekala::School.controllers :v1, :schools  do
  before :except => [] do

    if session[:school_id]
      @school = School.get(session[:school_id])
    else
      redirect_to(url(:v1, :unlogin))
    end

  end

  get :teachers, :provides => [:json] do
    @teachers = @school.teachers.all(:open => 1)
    @total  = @teachers.count
    render 'teachers'
  end

  get :fields, :provides => [:json] do
    @fields = @school.train_fields.all(:open => 1)
    @total  = @fields.count
    render 'fields'
  end

  get :products, :provides => [:json] do
    @products = @school.products.all(:show => 1)
    @total  = @products.count
    render 'products'
  end

  get :users, :provides => [:json] do
    @users = @school.users
    @total  = @users.count
    render 'users'
  end

end