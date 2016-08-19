Tekala::Admin.controllers :device do
  get :index do
    @title  = '设备管理'
    render "/device/index"
  end

end