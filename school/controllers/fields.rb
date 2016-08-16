Tekala::School.controllers :v1, :fields  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
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

  get :field, :map => '/v1/fields/:id', :provides => [:json] do
    @field  =  TrainField.get(params[:id])
    render 'field'
  end

  post :fields, :map => '/v1/fields', :provides => [:json] do
    if params[:name].present?
      @field = TrainField.new(:name => params[:name], :school_id => @school.id)
      @field.address            = params[:address]       if params[:address].present?
      @field.longitude          = params[:longitude]     if params[:longitude].present?
      @field.latitude           = params[:latitude]      if params[:latitude].present?
      if @field.save
        render 'field'
      else
        {:status => :failure, :msg => @field.errors.first.first}.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  get :teachers, :map => '/v1/fields/:id/teachers', :provides => [:json] do
    field  =  TrainField.get(params[:id])
    if field.present?
      @teachers  =  field.teachers
    end
    render 'teachers'
  end

  get :cars, :map => '/v1/fields/:id/cars', :provides => [:json] do
    field  =  TrainField.get(params[:id])
    if field.present?
      @cars  =  field.cars
    end
    render 'cars'
  end

  get :users, :map => '/v1/fields/:id/users', :provides => [:json] do
    field  =  TrainField.get(params[:id])
    if field.present?
      @users  =  field.users
    end
    render 'users'
  end

end
