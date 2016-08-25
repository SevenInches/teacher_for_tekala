Tekala::Admin.controllers :order do
  get :index do
    @title  = '约车管理'
    @order  = Order.all(:school_id => session[:school_id])
    if params[:type] == 'student'
      @user  = User.first(:name => params[:name])
      if @user
        @order = @order.all(:user_id => @user[:id])
      elsif
        flash[:warning] = pat(:search_error, :model => 'User')
      end
    elsif params[:type] == 'teacher'
      @teacher = Teacher.first(:name => params[:name])
      if @teacher
        @order = @order.all(:teacher_id => @teacher[:id])
      elsif
        flash[:warning] = pat(:search_error, :model => 'User')
      end
    end
    @order = @order.paginate(:page => params[:page],:per_page => 20)
    render "order/index"
  end
end
