Tekala::School.controllers :v1, :shops  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  # 使用该接口来返回驾校管理所需要的门店信息
  get :shops, :map => '/v1/shops', :provides => [:json] do
    if params['demo'].present?
      @demo = params['demo']
      @shops = Shop.first
      @total = 1
    else
      @shops = @school.shops
      @shops = shops.all(:name => params[:name]) if params[:name].present?
      @total = @shops.count
      @shops = @shops.paginate(:per_page => 20, :page => params[:page])
    end
    
    render 'shops'
  end

  # 使用该接口来添加驾校管理所需要的门店信息
  post :shops, :map => '/v1/shops', :provides => [:json] do
    if params[:name].present? && params[:address].present?
      @shop = Shop.new
      @shop.name = params[:name]
      @shop.address = params[:address]
      @shop.latitude = params[:latitude] if params[:latitude].present?
      @shop.longtitude = params[:longtitude] if params[:longtitude].present?
      @shop.area = params[:area] if params[:area].present?
      @shop.rent_amount = params[:rent_amount] if params[:rent_amount].present?
      @shop.contact_user = params[:contact_user] if params[:contact_user].present?
      @shop.contact_phone = params[:contact_phone] if params[:contact_phone].present?
      @shop.profile = params[:profile] if params[:profile].present?
      @shop.school_id = @school.id
      if @shop.save
        render 'shop'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :shops, :map => '/v1/shops', :provides => [:json] do
    if params[:id].present?
      @shop = Shop.get(params[:id])
      @shop.name   = params[:name]            if params[:name].present?
      @shop.address   = params[:address]      if params[:address].present?
      @shop.latitude   = params[:latitude]      if params[:latitude].present?
      @shop.longtitude = params[:longtitude]    if params[:longtitude].present?
      @shop.area       = params[:area]    if params[:area].present?
      @shop.rent_amount   = params[:rent_amount]    if params[:rent_amount].present?
      @shop.contact_user  = params[:contact_user]   if params[:contact_user].present?
      @shop.contact_phone = params[:contact_phone]  if params[:contact_phone].present?
      @shop.profile       = params[:profile]  if params[:profile].present?
      if @shop.save
        render 'shop'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  delete :shops, :map => '/v1/shops', :provides => [:json] do
    if params[:shop_id].present?
      shop      = Shop.get(params[:shop_id])
      shop_name = shop.name
      if shop.destroy
        {:status => :success, :msg => "#{shop_name}已经被删除"}.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

end