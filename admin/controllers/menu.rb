# Tekala::Admin.controllers :menu do
#   get :index do
#     @title  = '菜单管理'
#     @menus  = Subpart.all(:order => :weight)
#     render "/menu/index"
#   end
#
#   get :edit ,:with => :id do
#     @title  = '菜单编辑'
#     @menu  = Subpart.first(:id => params[:id])
#     render "/menu/edit"
#   end
#
#   post :update do
#     @menu = Subpart.first(:id => params[:user][:id])
#     if @menu
#       params[:user].each do |param|
#         @menu[param[0]] = param[1] if param[1].present?
#       end
#       if @menu.save
#         flash[:success] = pat(:update_success, :model => 'Menu', :id =>  "#{params[:id]}")
#         redirect(url(:menu, :index))
#       else
#         flash.now[:error] = pat(:update_error, :model => 'Menu')
#         render 'menu/edit/' + @menu.id
#       end
#     else
#       flash[:warning] = pat(:update_warning, :model => 'Menu', :id => "#{params[:id]}")
#       halt 404
#     end
#     redirect url(:menu, :index)
#   end
#
# end