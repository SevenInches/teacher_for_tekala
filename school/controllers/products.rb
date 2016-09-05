Tekala::School.controllers :v1, :products  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :products, :map => '/v1/products', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @products = Product.first(:show => 1)
      @total    = 1
    else
      @products = @school.products.all(:show => 1)
      @total    = @products.count
      @products = @products.all(:order => :created_at.desc).paginate(:per_page => 20, :page => params[:page])
    end
    render 'products'
  end

  post :products, :map => '/v1/products', :provides => [:json] do
    if params[:name].present?
      @product = Product.new
      @product.name          = params[:name]
      @product.detail        = params[:detail]        if params[:detail].present?
      @product.price         = params[:price]
      @product.promotion	   = params[:promotion]     if params[:promotion].present?
      @product.description   = params[:description]   if params[:description].present?
      @product.introduction  = params[:introduction]  if params[:introduction].present?
      @product.exam_type     = params[:exam_type]     if params[:exam_type].present?
      @product.show          = 1
      @product.city_id       = @school.city_id
      @product.school_id     = @school.id
      if @product.save
        render 'product'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :products, :map => '/v1/products/:product_id', :provides => [:json] do
    @product = Product.get(params[:id])
    if @product.present?
      @product.name          = params[:name]      if params[:name].present?
      @product.detail        = params[:detail]    if params[:detail].present?
      @product.price         = params[:price]     if params[:price].present?
      @product.promotion	   = params[:promotion] if params[:promotion].present?
      @product.show          = params[:show]      if params[:show].present?
      @product.description   = params[:description]   if params[:description].present?
      @product.introduction  = params[:introduction]  if params[:introduction].present?
      @product.exam_type     = params[:exam_type]     if params[:exam_type].present?
      if @product.save
        render 'product'
      end
    else
      {:status => :failure, :msg => '班别不存在'}.to_json
    end
  end

  delete :products, :map => '/v1/products/:product_id', :provides => [:json] do
    product = Product.get(params[:product_id])
    if product.present?
      product_name = product.name
      if product.destroy
        {:status => :success, :msg => "#{product_name}已经被删除"}.to_json
      end
    else
      {:status => :failure, :msg => '班别不存在'}.to_json
    end
  end
end