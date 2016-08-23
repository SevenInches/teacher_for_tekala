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
          @teachers  = @teachers.all(:mobile.like => "%#{params[:key]}%")
        else
          @teachers  = @teachers.all(:name.like => "%#{params[:key]}%")
        end
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
      if params[:field].present?
        fields = TeacherTrainField.all(:train_field_id => params[:field])
        if fields.present?
          teacher_ids  = fields.aggregate(:teacher_id)
          @teachers  = @teachers.all(:id => teacher_ids)
        end
      end
      if params[:branch].present?
        @teachers  = @teachers.all(:branch_id => params[:branch])
      end

      @total = @teachers.count
      @teachers  = @teachers.all(:order => :created_at.desc).paginate(:per_page => 20, :page => params[:page])
    end
    render 'teachers'
  end

  get :teacher, :map => '/v1/teachers/:teacher_id', :provides => [:json] do
    @teacher  =  Teacher.get(params[:teacher_id])
    render 'teacher'
  end

  post :teachers, :map => '/v1/teachers', :provides => [:json] do
    if params[:name].present?
      @teacher = Teacher.new(:name => params[:name], :school_id => @school.id)
      @teacher.mobile           = params[:mobile]     if params[:mobile].present?
      @teacher.branch_id        = params[:branch]     if params[:branch].present?
      @teacher.tech_type        = params[:tech]       if params[:tech].present?
      @teacher.exam_type        = params[:exam]       if params[:exam].present?
      @teacher.id_card          = params[:card]       if params[:card].present?
      @teacher.sex              = params[:sex]        if params[:sex].present?
      @teacher.address          = params[:address]    if params[:address].present?
      @teacher.bank_name        = params[:bank_name]  if params[:bank_name].present?
      @teacher.bank_card        = params[:bank_card]  if params[:bank_card].present?
      @teacher.wechat           = params[:wechat]     if params[:wechat].present?
      @teacher.password         = '123456'
      if @teacher.save
        if params[:field].present?
          TeacherTrainField.new(:teacher_id => @teacher.id, :train_field_id => params[:field].to_i).save
        end
        if params[:number].present?
          car = Car.first(:number => params[:number])
          if car.present?
            car.update(:teacher_id => @teacher.id)
          end
        end
        render 'teacher'
      else
        {:status => :failure, :msg => @teacher.errors.first.first }.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :teachers, :map => '/v1/teachers/:teacher_id', :provides => [:json] do
    @teacher = Teacher.get(params[:teacher_id])
    if @teacher.present?
      @teacher.mobile           = params[:mobile]     if params[:mobile].present?
      @teacher.branch_id        = params[:branch]     if params[:branch].present?
      @teacher.tech_type        = params[:tech]       if params[:tech].present?
      @teacher.exam_type        = params[:exam]       if params[:exam].present?
      @teacher.id_card          = params[:card]       if params[:card].present?
      @teacher.sex              = params[:sex]        if params[:sex].present?
      @teacher.address          = params[:address]    if params[:address].present?
      @teacher.bank_name        = params[:bank_name]  if params[:bank_name].present?
      @teacher.bank_card        = params[:bank_card]  if params[:bank_card].present?
      @teacher.wechat          = params[:wechat]    if params[:wechat].present?
      @teacher.name             = params[:name]       if params[:name].present?
      if @teacher.save
        if params[:field].present?
          TeacherTrainField.first(:teacher_id => @teacher.id).update(:train_field_id => params[:field])
        end
        render 'teacher'
      else
        {:status => :failure, :msg => @teacher.errors.to_s}.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  delete :teachers, :map => '/v1/teachers/:teacher_id', :provides => [:json] do
    teacher_field  =  TeacherTrainField.first(:teacher_id => params[:teacher_id])
    if teacher_field.present?
      teacher_field.destroy
    end
    teacher  = Teacher.get(params[:teacher_id])
    if teacher.present?
      if teacher.destroy!
        {:status => :success, :msg => "教练(id:#{params[:teacher_id]})删除成功"}.to_json
      else
        {:status => :failure, :msg => '删除错误'}.to_json
      end
    end
  end

  get :comments, :map => '/v1/teachers/:teacher_id/comments', :provides => [:json] do
    teacher     = Teacher.get(params[:teacher_id])
    if teacher.present?
      @comments   = teacher.comments
      @total      = @comments.count
      render 'comments'
    end
  end

  get :show, :map => 'v1/teachers/:teacher_id/comments/:id', :provides => [:json] do
    @comment = TeacherComment.get(params[:id])
    if @comment
      render 'comment'
    else
      {:status => :failure, :msg => '未能找到该评论'}.to_json
    end
  end

  delete :comments, :map => 'v1/teachers/:teacher_id/comments/:id', :provides => [:json] do
    @comment = TeacherComment.first(:id => params[:id])
    if @comment.present?
      { :status => @comment.destroy ? :success : :failure }.to_json
    else
      { :status => :failure, :msg => '该评论已删除' }.to_json
    end
  end

  get :orders, :map => '/v1/teachers/:teacher_id/orders', :provides => [:json] do
    teacher = Teacher.get(params[:teacher_id])
    if teacher.present?
      @orders = teacher.orders.all(:order => :book_time.desc)
      @total  = @orders.count
      render 'orders'
    end
  end

  get :pays, :map => '/v1/teachers/:teacher_id/pays', :provides => [:json] do
    teacher = Teacher.get(params[:teacher_id])
    if teacher.present?
      @logs = teacher.pay_logs.all(:order => :pay_date.desc)
      @total  = @logs.count
      render 'pay_logs'
    end
  end
end
