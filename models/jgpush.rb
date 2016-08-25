# 极光推送
class JGPush

  #学员版本
  KEY = "164d07f0e6d086a219295841"
  SEC = "07850c205a6b60c8ab7a0543"

  #教练版
  TEACHERKEY = "666bfd915856f8db083da084"
  TEACHERSEC = "db8e69cb1c8a6458d91c6f02"

  #驾校版
  SCHOOLKEY = "53b5400b0cddd0a1082b4c7c"
  SCHOOLSEC = "ece89cbac8c32d2e7697737f"

  #门店版
  SHOPKEY = "9a33f3b03cdd83373b357414"
  SHOPSEC = "9af36422b37bc459adc6fe2c"

  #代理版
  CHANNELKEY = "56c1a0a82735f9baea8bb629"
  CHANNELSEC = "25d896b5d83189aea9c3d042"

  APNS_PRODUCTION = "true"

  URL = URI('https://api.jpush.cn/v3/push')

  #推送给管理app
  def self.send message="有新教练加入啦!"

    Net::HTTP.start(URL.host, URL.port,:use_ssl => URL.scheme == 'https') do |http|
      @count = Teacher.count
      req=Net::HTTP::Post.new(URL.path)
      req.basic_auth KEY,SEC
      jpush =[]
      jpush << 'platform=all'
      jpush << 'audience=all'

      jpush << 'notification={

            "ios":{
                   "alert":"'+message+'",
                   "content-available":1,
                   "extras":{"type": "teacher", "msg": "'+message+'", "count": "'+@count.to_s+'" }
                     }
                  }'
      jpush << 'options={"time_to_live":60,"apns_production" : '+APNS_PRODUCTION+'}'
      req.body = jpush.join("&")
      resp=http.request(req)
      p resp.body
    end
  end

  def self.send_one(account, msg, type, data) 
    Net::HTTP.start(URL.host, URL.port,:use_ssl => URL.scheme == 'https') do |http|
        req=Net::HTTP::Post.new(URL.path)
        req.basic_auth KEY,SEC
        jpush =[]
        jpush << 'platform=all'
        jpush << 'audience={"alias" : ["'+account.to_s+'"]}'

        jpush << 'notification={
            "alert":"'+msg+'",
            "android" : {
                   "extras":{"type"  : "'+type+'", "id" : "'+data+'"
                   }
                },
            "ios":{
                   "content-available":1,
                   "extras":{"type"  : "'+type+'", "id" : "'+data+'"
                        }
                     }
                  }'
        jpush << 'options={"time_to_live":60,"apns_production" : '+APNS_PRODUCTION+'}'
        req.body = jpush.join("&")
        resp=http.request(req)
    end
  end  

  def self.send_phone(phone, msg)
    Net::HTTP.start(URL.host, URL.port,:use_ssl => URL.scheme == 'https') do |http|
        req=Net::HTTP::Post.new(URL.path)
        req.basic_auth KEY,SEC
        jpush =[]
        jpush << 'platform=all'
        jpush << 'audience={"alias" : ["'+phone.to_s+'"]}'

        jpush << 'notification={
            "alert":"'+msg+'",
            "ios":{
                 "content-available":1,
                 "extras":{"type": "message", "msg": "'+msg+'" }
                   }
                }'
        jpush << 'options={"time_to_live":60,"apns_production" : '+APNS_PRODUCTION+'}'
        req.body = jpush.join("&")
        resp=http.request(req)
        
    end
  end

  def self.send_version(version, msg)
    Net::HTTP.start(URL.host, URL.port,:use_ssl => URL.scheme == 'https') do |http|
        req=Net::HTTP::Post.new(URL.path)
        req.basic_auth KEY,SEC
        jpush =[]
        jpush << 'platform=all'
        jpush << 'audience={"alias" : ["'+version.to_s+'"]}'

        jpush << 'notification={
            "alert":"'+msg+'",
            "ios":{
                 "content-available":1,
                 "extras":{"type": "message", "msg": "'+msg+'" }
                   }
                }'
        jpush << 'options={"time_to_live":60,"apns_production" : '+APNS_PRODUCTION+'}'
        req.body = jpush.join("&")
        resp=http.request(req)
    end
  end

  #确认新订单
  def self.confirm_order order_id
    order = Order.get order_id
    tname = order.teacher.name

    current_alias = "user_"+order.user_id.to_s

    jpush = JPush::Client.new(KEY,SEC)

    pusher = jpush.pusher

    audience = JPush::Push::Audience.new.set_alias(current_alias)

    extras   = {type: "confirm_order", msg: "#{tname}教练已接单", order_id: order_id}

    notification = JPush::Push::Notification.new.
        set_android(
            alert: "#{tname}教练已接单",
            title: "教练已接单",
            extras: extras
        ).set_ios(
        alert: "#{tname}教练已接单",
        available: true,
        extras: extras
    )

    push_payload = JPush::Push::PushPayload.new(
        platform: 'all',
        audience: audience,
        notification: notification,
    ).set_message(
        "#{tname}教练已接单",
        title: "教练已接单",
        content_type: 'text',
        extras: extras
    )

    begin
      pusher.push(push_payload)
    rescue
      {status: :failure, msg: '推送失败'}.to_json
    end

  end #order_confirm

  #订单被学员取消了
  def self.order_cancel order_id

    order = Order.get order_id

    if order.order_confirm.present? && order.order_confirm.status == 2

      #如果是教练取消了订单 推送给学员
      current_alias = "user_"+order.user_id.to_s

      jpush = JPush::Client.new(KEY,SEC)

      pusher = jpush.pusher

      audience = JPush::Push::Audience.new.set_alias(current_alias)

      extras   = {type: "order_cancel", msg: "啊哦～教练太忙接不过来单，预约其他时间或者换个教练试试？", order_id: order_id}

      notification = JPush::Push::Notification.new.
          set_android(
              alert: "啊哦～教练太忙接不过来单，预约其他时间或者换个教练试试？",
              title: "教练拒单",
              extras: extras
          ).set_ios(
          alert: "啊哦～教练太忙接不过来单，预约其他时间或者换个教练试试？",
          available: true,
          extras: extras
      )

      push_payload = JPush::Push::PushPayload.new(
          platform: 'all',
          audience: audience,
          notification: notification
      ).set_message(
          "啊哦～教练太忙接不过来单，预约其他时间或者换个教练试试？",
          title: "教练拒单",
          content_type: 'text',
          extras: extras
      )

      begin
        pusher.push(push_payload)
      rescue
        {status: :failure, msg: '推送失败'}.to_json
      end
    end

  end #order_cancel


  #订单开始前1个小时推送 您的学车预约即将开始，立即查看
  def self.order_remind  order_id 
    order = Order.get order_id
    return false if order.nil?

    username   = order.user.name
    time       = order.book_time.strftime('%H:%M')
    trainfield = order.train_field.name

    #提醒学员
    current_alias1 = "user_"+order.user_id.to_s

    jpush1 = JPush::Client.new(KEY,SEC)

    pusher1 = jpush1.pusher

    audience = JPush::Push::Audience.new.set_alias(current_alias1)

    extras   = {type: "order_remind", msg: "1个小时后教练教你学车带你飞，现在你准备好了吗？", order_id: order_id}

    notification = JPush::Push::Notification.new.
        set_android(
            alert: "1个小时后教练教你学车带你飞，现在你准备好了吗？",
            title: "学车提醒",
            extras: extras
        ).set_ios(
        alert: "1个小时后教练教你学车带你飞，现在你准备好了吗？",
        available: true,
        extras: extras
    )

    push_payload1 = JPush::Push::PushPayload.new(
        platform: 'all',
        audience: audience,
        notification: notification
    ).set_message(
        "1个小时后教练教你学车带你飞，现在你准备好了吗？",
        title: "学车提醒",
        content_type: 'text',
        extras: extras
    )

    begin
      pusher1.push(push_payload1)
    rescue
      {status: :failure, msg: '推送失败'}.to_json
    end

    #提醒教练
    current_alias2 = "teacher_"+order.teacher_id.to_s

    jpush2  = JPush::Client.new(KEY,SEC)

    pusher2 = jpush2.pusher

    audience = JPush::Push::Audience.new.set_alias(current_alias2)

    extras   = {type: "order_remind", msg: "行程提醒：学员#{username}于#{time}在#{trainfield}练车", order_id: order_id}

    notification = JPush::Push::Notification.new.
        set_android(
            alert: "行程提醒：学员#{username}于#{time}在#{trainfield}练车",
            title: "order_remind",
            extras: extras
        ).set_ios(
        alert: "行程提醒：学员#{username}于#{time}在#{trainfield}练车",
        available: true,
        extras: extras
    )

    push_payload2 = JPush::Push::PushPayload.new(
        platform: 'all',
        audience: audience,
        notification: notification
    ).set_message(
        "行程提醒：学员#{username}于#{time}在#{trainfield}练车",
        title: "order_remind",
        content_type: 'text',
        extras: extras
    )

    begin
      pusher2.push(push_payload2)
    rescue
      {status: :failure, msg: '推送失败'}.to_json
    end

  end #order_remind

  def self.send_daily(school_id, content)

    school = School.get school_id
    return false if school.nil?

    title  = school.name.present? ? (school.name + '日报') : '日报'

    current_alias = "school_" + school_id.to_s

    jpush  = JPush::Client.new(SCHOOLKEY,SCHOOLSEC)

    pusher = jpush.pusher

    audience = JPush::Push::Audience.new.set_alias(current_alias)

    extras   = {type: "daily", msg: content}

    notification = JPush::Push::Notification.new.
        set_android(
            alert: content,
            title: title,
            extras: extras
        ).set_ios(
        alert: content,
        available: true,
        extras: extras
    )

    push_payload = JPush::Push::PushPayload.new(
        platform: 'all',
        audience: audience,
        notification: notification
    ).set_message(
        content,
        title: title,
        content_type: 'text',
        extras: extras
    )

    begin
      pusher.push(push_payload)
    rescue
      {status: :failure, msg: '推送失败'}.to_json
    end

  end

  def self.send_message(tags, msg, edition)
    key, sec= convert_edition(edition)
    Net::HTTP.start(URL.host, URL.port,:use_ssl => URL.scheme == 'https') do |http|
      req=Net::HTTP::Post.new(URL.path)
      req.basic_auth key, sec
      jpush =[]
      jpush << 'platform=all'
      jpush << 'audience={"tag_and" : '+tags.to_s+'}'
      jpush << 'notification={
            "alert":"'+msg+'",
            "ios":{
                 "content-available":1,
                 "extras":{"type": "message", "msg": "'+msg+'" }
                   }
                }'
      jpush << 'message={ "msg_content" : "'+msg+'", "content_type": "text", "title": "消息推送" }'
      jpush << 'options={"time_to_live":60,"apns_production" : '+APNS_PRODUCTION+'}'
      req.body = jpush.join("&")
      resp=http.request(req)
    end
  end

  def self.convert_edition(key)
    case key.to_i
      when 1 then return KEY,SEC
      when 2 then return TEACHERKEY,TEACHERSEC
      when 3 then return SCHOOLKEY,SCHOOLSEC
      when 4 then return SHOPKEY,SHOPSEC
      when 5 then return CHANNELKEY,CHANNELSEC
    end
  end

end
