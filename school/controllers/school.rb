Tekala::School.controllers :v1, :schools  do
  before :except => [] do

    if session[:school_id]
      @school = School.get(session[:school_id])
    else
      redirect_to(url(:v1, :unlogin))
    end

  end

  get :teachers, :map => '/v1/teachers', :provides => [:json] do
    @teachers = @school.teachers.all(:open => 1)
    @total  = @teachers.count
    render 'teachers'
  end

  get :fields, :map => '/v1/fields', :provides => [:json] do
    @fields = @school.train_fields.all(:open => 1)
    @total  = @fields.count
    render 'fields'
  end

  get :products, :map => '/v1/products', :provides => [:json] do
    @products = @school.products.all(:show => 1)
    @total  = @products.count
    render 'products'
  end

  get :users, :map => '/v1/users', :provides => [:json] do
    @users = @school.users
    @total  = @users.count
    render 'users'
  end

end