Tekala::Admin.controllers :help do
  get :index do
    @title = '使用帮助'

    render "help/index"
  end
end
