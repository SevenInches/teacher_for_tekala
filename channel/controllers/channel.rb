Tekala::Channel.controllers :v1, :channels  do

  before :except => [] do
    if session[:channel_id]
      @channel = Channel.get(session[:channel_id])
    else
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :consultants, :map => '/v1/consultants', :provides => [:json] do
    @consultants = @shop.consultants
    @total = @consultants.count
    @consultants = @consultants.paginate(:per_page => 20, :page => params[:page])
    render 'consutiltants'
  end

  get :students, :map => '/v1/students', :provides => [:json] do
      @students = @shop.students
      @total = @students.count
      @students = @students.paginate(:per_page => 20, :page => params[:page])
      render 'students'
  end

  post :add_consultants, :provides => [:json], :map => '/v1/add_consultants' do 
    consultant  = Consultant.create(:name => params[:name], :sex => params[:sex], :mobile => params[:mobile], :age => params[:age], :shop_id => @shop.id)
    if consultant.mobile.to_i.size != consultant.mobile.size
      return {:status => :failure, :msg => '添加失败，手机号错误'}.to_json
    end

    if consultant.save
      {:status => :success, :msg => '添加成功'}.to_json
    else
      {:status => :failure, :msg => '添加失败'}.to_json
    end
  end

  delete :delete_consultants, :provides => [:json], :map => '/v1/delete_consultants' do
    ids = params[:id].split ","
    consultants = Consultant.all(:id => ids) # 待测试
    if consultants.destroy
      {:status => :success, :msg => '删除成功'}.to_json
    else
      {:status => :failure, :msg => '删除失败'}.to_json
    end
  end

  post :add_students, :provides => [:json], :map => '/v1/add_students' do 
    consultant = Consultant.get(params[:id].to_i)
    student = Student.create(:name => consultant.name, :sex => consultant.sex, :age => consultant.age, :mobile => consultant.mobile, :shop_id => @shop.id)
    if student.save
      consultant.destroy
      {:status => :success, :msg => '添加成功'}.to_json
    else
      {:status => :failure, :msg => '添加失败'}.to_json
    end
  end

  delete :delete_students, :provides => [:json], :map => '/v1/delete_students' do
    ids = params[:id].chars
    students = Student.all(:id => ids)
    if students.destroy
      {:status => :success, :msg => '删除成功'}.to_json
    else
      {:status => :failure, :msg => '删除失败'}.to_json
    end
  end

end