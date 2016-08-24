Tekala::Admin.controllers :order do
  get :index do
    @title  = '约车管理'
    @order  = Order.all(:school_id => session[:school_id])
    if params[:type] == 'student'
      @user  = User.first(:name => params[:name])
      @order = @order.all(:user_id => @user[:id])
    elsif params[:type] == 'teacher'
      @teacher = Teacher.first(:name => params[:name])
      @order   = @order.all(:teacher_id => @teacher[:id])
    end
    @order = @order.paginate(:page => params[:page],:per_page => 20)
    render "order/index"
  end
end
