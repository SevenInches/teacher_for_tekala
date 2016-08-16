Tekala::Admin.controllers :base do

  get :index, :map => "/" do
    render "index/index"
  end

end
