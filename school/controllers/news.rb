Tekala::School.controllers :v1, :news  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :news, :map => '/v1/news', :provides => [:json] do
    if params['demo'].present?
      @demo = params['demo']
      check = Check.first
      @cars = Car.get(check.car_id) if check.present?
      @total = 1
    else
      @cars = @school.cars
      if params[:branch].present?
        branches = params[:branch].split(/-/)
        @cars = @cars.all(:branch => branches)
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

end