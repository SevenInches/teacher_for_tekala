Tekala::Admin.controllers :import do
  get :index do
    @user = User.all(:school_id => session[:school_id])
    render "import/index"
  end

  post :import do
    if params['file'].present?
      excel_name   = 'public/uploads/excels/'+params['file'][:filename]

      File.open(excel_name, "w") do |f|
        f.write(params['file'][:tempfile].read.force_encoding('utf-8'))
      end

      xlsx  = Roo::Excelx.new(excel_name)
      sheet = xlsx.sheet('Worksheet1')

      puts sheet.count
      #遍历excel列
      (2..(sheet.count)).each do |row|
        name          = sheet.cell("B", row)
        mobile        = sheet.cell("C", row).to_i
        status_flag   = sheet.cell("D", row)
        exam_type     = sheet.cell("E", row)
        school        = sheet.cell("F", row)

        #创建一个学员
        user = User.first(:mobile => mobile)
        if !user.present?
          user = User.new(:mobile => mobile)
        end
        user.name        = name
        user.exam_type   = User.exam_type_reverse(exam_type)
        user.status_flag = User.status_flag_reverse(status_flag)
        user.school_id   = School.first_school_id(school)
        user.password    = '123456'
        if user.save
          flash[:success] = pat(:inport_success, :model => 'User')
        end
      end
    end
    redirect(url(:users, :index))
  end

  get :export do
    @users = User.all(:school_id => session[:school_id])
    # @users  = @users.all(:name.like => "%#{params[:name]}%")    if params[:name].present?
    # @users  = @users.all(:mobile  => params[:mobile])           if params[:mobile].present?
    # @users  = @users.all(:status_flag => params[:status_flag])  if params[:status_flag].present?
    #
    # @users  = @users.all(:exam_type => params[:exam_type]) if params[:exam_type].present?
    # @users  = @users.all(:school_id => params[:school_id]) if params[:school_id].present?
    # @users  = @users.all(:product_id => params[:product_id]) if params[:product_id].present?

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet[0,0]    = "#id"
    sheet[0,1]    = "学员姓名"
    sheet[0,2]    = "手机号"
    sheet[0,3]    = "状态"
    sheet[0,4]    = "班别"
    sheet[0,5]    = "驾考类型"
    sheet[0,6]    = "报名时间"
    format = Spreadsheet::Format.new :color => :blue,
                                     :weight => :bold,
                                     :size => 15
    sheet.row(0).default_format = format

    @users.each_with_index do |user,index|
      sheet[index+1,0]    = user.id
      sheet[index+1,1]    = user.name
      sheet[index+1,2]    = user.mobile
      sheet[index+1,3]    = user.status_flag_word
      sheet[index+1,4]    = user.signup ? user.signup.product.name : ''
      sheet[index+1,5]    = user.exam_type_word
      sheet[index+1,6]    = user.created_at.to_s[0..9]
    end

    output_file_name = "user_#{Time.now.to_i}.xls"
    book.write "public/uploads/#{output_file_name}"

    redirect "/uploads/#{output_file_name}"
  end

end
