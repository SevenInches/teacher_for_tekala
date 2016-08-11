Tekala::Admin.controllers :base do

  get :index, :map => "/" do
    render "roles/index"
  end

end
