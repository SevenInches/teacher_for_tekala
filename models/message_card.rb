class MessageCard
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :content, String
  #消息类型: 1=>驾校新闻, 2=>驾校日报, 3=>系统推送
  property :type, Integer
  property :school_id, Integer
  property :message_id, Integer
  property :weight, Integer
  property :open, Boolean, :default => 1
  property :created_at, DateTime

  CONSANT_PREFIX  = (Padrino.env == :production) ? 'http://t.tekala.cn/school/v1/' : 'localhost:8765/school/v1/'

   def date
    created_at.strftime('%y年%m月%d日') if created_at.present?
  end

  def type_word
    case type
      when 1 then '驾校新闻'
      when 2 then '驾校日报'
      when 3 then '系统推送'
    end
  end

  def url
    case type
      when 1 then CONSANT_PREFIX + 'news_card/' + message_id.to_s
      when 2 then CONSANT_PREFIX + 'daily_card/'+ message_id.to_s
      when 3 then CONSANT_PREFIX + 'push_card/' + message_id.to_s
    end
  end

end
