Tekala::School.controllers :v1, :teachers  do

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
      $school_remark  = 'school_' + session[:school_id].to_s
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :teachers, :map => '/v1/teachers', :provides => [:json] do
    if params['demo'].present?
      @demo    =  params['demo']
      @teachers   =  @school.teachers.first
      @total   =  1
    else
      @teachers  = @school.teachers
      if params[:key].present?
        if params[:key].to_i > 0
          @teachers  = @teachers.all(:mobile => params[:key])
        else
          @teachers  = @teachers.all(:name => params[:key])
        end
      end

      if params[:status].present?
        @teachers  = @teachers.all(:status_flag => params[:status])
      end
      if params[:tech_type].present?
        @teachers  = @teachers.all(:exam_type => params[:exam_type])
      end
      if params[:exam_type].present?
        @teachers  = @teachers.all(:exam_type => params[:exam_type])
      end
      if params[:sex].present?
        @teachers  = @teachers.all(:sex => params[:sex])
      end

      @total = @teachers.count
      @teachers  = @teachers.paginate(:per_page => 20, :page => params[:page])
    end
    render 'teachers'
  end

end
