class Push
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :message, String
  property :type, Integer
  property :value, String
  property :channel_id, Integer
  property :version, String
  property :school_id, Integer
  property :user_status, Boolean
  property :editions, String

  property :arrive, Integer, :default => 0
  property :created_at, DateTime
  property :update_at, DateTime

  belongs_to :channel
  belongs_to :school

  after :save, :jpush

  def self.get_type(key=nil)
    words = {
        1 => '版本更新',
        2 => '活动消息',
        3 => '报名订单',
        4 => '约车订单',
        5 => '消息',
        6 => '动态'
    }
    if key.present?
      words[key]
    else
      words
    end
  end

  def self.get_user_status(key=nil)
    words = {
        0 => '未报名',
        1 => '已报名'
    }
    if !key.nil?
      key ? words[1] : words[0]
    else
      words
    end
  end

  def self.get_editions(key=nil)
    words = {
        1 => '学员版',
        2 => '教练版',
        3 => '驾校版',
        4 => '门店版',
        5 => '代理渠道版'
    }
    if key.present?
      words[key]
    else
      words
    end
  end

  def push_word
    case channel_id
      when 1
        "学员版"
      when 2
        "教练版"
      when 3
        "驾校版"
      when 4
        "门店版"
      else
        "代理渠道版"
    end
  end

  def editions_name
    if editions.present?
      array = editions.split(":")
      names = []
      array.each do |a|
        names << Push.get_editions(a.to_i)
      end
      names.join(",")
    end
  end

  def editions_name_convertion
    if editions.present?
      array = editions.split(":")
      names = []
      array.each do |a|
        names << '<span class="edition-'+ a +'">' + Push.get_editions(a.to_i) + '</span>'
      end
      names.join("")
    end
  end

  def type_demo
    '消息类别: 1 => 版本更新, 2 => 活动消息, 3 => 报名订单, 4 => 约车订单, 5 => 消息, 6 => 动态'
  end

  def editions_demo
    '客户端类型: 1 => 学员版, 2 => 教练版, 3 => 驾校版, 4 => 门店版, 5 => 代理渠道版'
  end

  def jpush
    tags = []
    if editions.present?
      editions.split(':').each do |edition|
        if edition == '3'
          JGPush.send_school_message(message, school_id)
        else
          tags << 'channel_' + channel_id.to_s if channel_id.present?
          tags << 'version_' + version if version.present?
          tags << 'school_'  + school_id.to_s if school_id.present?
          tags << 'status_'  + user_status.to_s if !user_status.nil?
          JGPush.send_message(tags, message, edition)
        end
        tags.clear
      end
    end
  end

end
