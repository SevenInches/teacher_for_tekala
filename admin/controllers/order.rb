Tekala::Admin.controllers :order do
  get :index do
    @title  = '约车管理'
    @order  = Order.all(:school_id => session[:school_id])
    @order = @order.paginate(:page => params[:page],:per_page => 20)
    render "order/index"
  end
end
