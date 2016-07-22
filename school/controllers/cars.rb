Tekala::School.controllers :v1, :cars  do

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :cars, :map => '/v1/cars', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @cars    = Car.first
      @total    = 1
    else
      @cars  = @school.cars
      @cars  = @cars.all(:number => params[:number])               if params[:number].present?
      @cars  = @cars.all(:produce_year => params[:produce_year])   if params[:produce_year].present?
      @cars  = @cars.all(:identify => params[:identify])           if params[:identify].present?
      @total = @cars.count
      @cars  = @cars.paginate(:per_page => 20, :page => params[:page])
    end
    render 'cars'
  end

  post :cars, :map => '/v1/cars', :provides => [:json] do
    if params[:number].present?
      @car = Car.new
      @car.brand     = params[:brand ]
      @car.number    = params[:number]
      @car.identify	 = params[:identify	]
      @car.note      = params[:note]   if params[:note].present?
      @car.name      = params[:name]   if params[:name].present?
      @car.produce_year     = params[:produce_year]   if params[:produce_year].present?
      @car.school_id  = @school.id
      if @car.save
        render 'car'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :cars, :map => '/v1/cars', :provides => [:json] do
    if params[:id].present?
      @car = Car.get(params[:id])
      @car.number     = params[:number]         if params[:number].present?
      @car.identify   = params[:identify]       if params[:identify].present?
      @car.brand      = params[:brand]          if params[:brand].present?
      @car.name       = params[:name]           if params[:name].present?
      @car.note       = params[:note]           if params[:note].present?
      @car.produce_year   = params[:produce_year]     if params[:produce_year].present?
      if @car.save
        render 'car'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  delete :cars, :map => '/v1/cars', :provides => [:json] do
    if params[:car_id].present?
      car      = Car.get(params[:car_id])
      car_name = car.name
      if car.destroy
        {:status => :success, :msg => "#{car_name}已经被删除"}.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end
end