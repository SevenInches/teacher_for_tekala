Szcgs::Coach.controllers  :v1, :settings  do
	before :except => [:validate_sms,:reset_password] do
	    
    if session[:teacher_id]
    	@teacher = Teacher.get(session[:teacher_id])
	  else
	    redirect_to(url(:v1, :unlogin))
	  end

	end
 
	post :info, :provides => [:json] do    

		@teacher.bank_name 		   = params[:bank_name]  if params[:bank_name]
		@teacher.bank_card 		   = params[:bank_card]  if params[:bank_card]
		@teacher.tech_type 		   = params[:tech_type]  if params[:tech_type]
		@teacher.city 	 		   = params[:city]  	 if params[:city]
		@teacher.bank_account_name = params[:bank_account_name]  if params[:bank_account_name]

		{:status => @teacher.save ? :success : :failure}.to_json   

	end

	post :password, :provides => [:json] do

	  password 		 = params[:password]
	  new_password   = params[:new_password]

	  @teacher = Teacher.authenticate(@teacher.mobile, password)

	  if @teacher
	  	@teacher.crypted_password = 'teacher modify password'
	  	@teacher.password = new_password
	  	
	  	{:status => @teacher.save ? :success : :failure }.to_json
	  else

	  	{:status => :failure, :code => 500, :msg => '密码错误'}.to_json

	  end

	end

	get :date_setting, :provides => [:json] do 
		
			{:status => :success,:data => JSON.parse(@teacher.date_setting_filter)}.to_json

	end

	post :date_setting, :provides => [:json] do 

		content = request.body.read
		week 	= JSON.parse(content.to_s)

		@teacher.date_setting = content.to_s
		if @teacher.save
			{:status => :success,
			 :date => JSON.parse(@teacher.date_setting_filter)}.to_json
		else
			{:status => :failure}.to_json
		end

	end

	post :add_train_field, :provides => [:json] do 
		teacher_train_field  = TeacherTrainField.first_or_create(:teacher_id => @teacher.id, :train_field_id => params[:train_field_id])
		if teacher_train_field.save
			teacher_train_field.sort = teacher_train_field.id
			teacher_train_field.save
			@train_field = TrainField.get teacher_train_field.train_field_id
			render 'train_field'
		else
			{:status => :failure, :msg => '添加失败'}.to_json
		end
	end

	post :remove_train_field, :provides => [:json] do 
		teacher_train_field = TeacherTrainField.all(:teacher_id => @teacher.id, :train_field_id => params[:train_field_id])
		if teacher_train_field.destroy 
			{:status => :success}.to_json
		else
			{:status => :failure}.to_json
		end
	end

	post :validate_sms, :provides => [:json] do

        @teacher = Teacher.first(:mobile => params[:mobile]);
        if @teacher 
            validate = UserValidate.first_or_create(:mobile => @teacher.mobile)
            validate.user_id = @teacher.id
            validate.code    = rand(1111..9999)

            sms = Sms.new(:content => "验证码：#{validate.code}，本条验证码10分钟内有效。", :member_mobile => validate.mobile)
            
            if validate.save && sms.validate
                {:status => :success}.to_json
            else
                {:status => :failure, :msg => '验证短信未能发送成功，请联系客服'}.to_json
            end
        else
        	{:status => :failure, :msg => '该手机未注册'}.to_json
        end

    end

    post :reset_password, :provides => [:json] do

     validate = UserValidate.first(:mobile => params[:mobile], :code =>  params[:code])
     if validate && validate.updated_at + 10.minutes >= Time.now

      teacher = Teacher.first(:mobile => params[:mobile])
      teacher.crypted_password = 'mmxueche_modify'
      teacher.password 	= params[:new_password]
      if teacher.save
      	validate.code  = rand(1111..9999)
      	validate.save
      	{:status => :success, :msg => '密码重置成功'}.to_json
      else
      	{:status => :failure, :msg => '密码重置失败'}.to_json
      end
     
     elsif validate && validate.updated_at + 10.minutes  < Time.now
      
      {:status => :failure, :msg => '验证码已过期，请重新验证'}.to_json
    
     else
      {:status => :failure, :msg => '验证码错误，请重新输入'}.to_json
     end

    end

end