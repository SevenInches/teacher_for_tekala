Tekala::Admin.controllers :finance do
  get :index do
    @title  = '财务管理'
    render "finance/index"
  end
end
