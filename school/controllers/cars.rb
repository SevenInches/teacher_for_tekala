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
      @demo    =  params['demo']
      check    =  Check.first
      @cars    =  Car.get(check.car_id) if check.present?
      @total   =  1
    else
      @cars  = @school.cars
      if params[:branch].present?
        branches = params[:branch].split(/-/)
        @cars  = @cars.all(:branch => branches)
      end
      if params[:field].present?
        fields = params[:field].split(/-/)
        @cars  = @cars.all(:train_field_id => fields)
      end
      if params[:exam_type].present?
        types = params[:exam_type].split(/-/)
        @cars  = @cars.all(:exam_type => types)
      end

      @cars  = @cars.all(:number => params[:number])               if params[:number].present?
      @cars  = @cars.all(:open => params[:open])                   if !params[:open].nil?

      if params[:not_handle].present?
        @checks  = Check.all(:second_check_end.gte =>  Date.today - 3.month)|Check.all(:season_check_end.gte =>  Date.today - 1.month)|Check.all(:year_check_end.gte =>  Date.today - 3.month)|Check.all(:check_end.gte =>  Date.today - 3.month)
        @car_ids = @checks.aggregate(:car_id)
        @cars    = @cars.all(:id => @car_ids)
      end
      @total = @cars.count
      @cars  = @cars.paginate(:per_page => 20, :page => params[:page])
    end
    render 'cars'
  end

  get :car, :map => '/v1/cars/:car_id', :provides => [:json] do
    @car = Car.get(params[:car_id])
    render 'car'
  end

  post :cars, :map => '/v1/cars', :provides => [:json] do
    if params[:number].present?
      @car = Car.new(:number => params[:number], :school_id => @school.id)
      @car.brand            = params[:brand]       if params[:brand].present?
      @car.branch_id        = params[:branch]      if params[:branch].present?
      @car.exam_type	      = params[:exam_type]   if params[:exam_type].present?
      @car.train_field_id   = params[:field]       if params[:field].present?
      @car.save
      check = Check.new(:car_id => @car.id )
      check.check_end       = params[:check_end]  if params[:check_end].present?
      check.year_check_end  = params[:year_check_end]  if params[:year_check_end].present?
      check.season_check_end  = params[:season_check_end]  if params[:season_check_end].present?
      check.second_check_end  = params[:second_check_end]  if params[:check_end].present?
      if check.save
        render 'car'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :cars, :map => '/v1/cars/:car_id', :provides => [:json] do
    @car = Car.get(params[:id])
    if @car.present?
      @car.brand       = params[:brand]       if params[:brand].present?
      @car.branch_id   = params[:branch]      if params[:branch].present?
      @car.exam_type	 = params[:exam_type]   if params[:exam_type].present?
      @car.number	     = params[:number]      if params[:number].present?
      @car.train_field_id   = params[:field]       if params[:field].present?
      @car.save
      check = @car.check
      check.check_end       = params[:check_end]  if params[:check_end].present?
      check.year_check_end  = params[:year_check_end]  if params[:year_check_end].present?
      check.season_check_end  = params[:season_check_end]  if params[:season_check_end].present?
      check.second_check_end  = params[:second_check_end]  if params[:check_end].present?
      if check.save
        render 'car'
      end
    else
      {:status => :failure, :msg => '车辆不存在'}.to_json
    end
  end

  get :open, :map => '/v1/cars/:id/open', :provides => [:json] do
    car = Car.get params[:id]
    car.open = !car.open
    if car.save!
      {:status => :success, :msg => '修改成功'}.to_json
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  delete :car, :map => '/v1/cars/:car_id', :provides => [:json] do
    car = Car.get(params[:car_id])
    if car.present?
      if car.destroy
        {:status => :success, :msg => '车辆删除成功'}.to_json
      else
        {:status => :success, :msg => car.errors.first.first }.to_json
      end
    else
      {:status => :failure, :msg => '车辆不存在'}.to_json
    end
  end
end