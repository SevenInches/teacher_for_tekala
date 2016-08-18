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
      names.join(":")
    end
  end

  def type_demo
    '消息类别: 1 => 版本更新, 2 => 活动消息, 3 => 报名订单, 4 => 约车订单, 5 => 消息, 6 => 动态'
  end

  def editions_demo
    '客户端类型: 1 => 学员版, 2 => 教练版, 3 => 驾校版, 4 => 门店版, 5 => 代理渠道版'
  end

  def self.jpush_message(push)
    tags = []
    if push.present? && push.editions.present?
      push.editions.split(':').each do |edition|
        tags << 'channel_' + push.channel_id.to_s if push.channel_id.present?
        tags << 'version_' + push.version if push.version.present?
        tags << 'school_'  + push.school_id.to_s if push.school_id.present?
        tags << 'status_'  + push.user_status.to_s if !push.user_status.nil?
        JPush.send_message(tags, push.message, edition)
      end
    end
  end

end
