DataMapper.logger = logger
DataMapper::Property::String.length(255)
require "redis"

case Padrino.env
  when :development then DataMapper.setup(:default, "mysql://mmxueche:ASDFghjkl2015@rm-wz93qf9u9x61ute9vo.mysql.rds.aliyuncs.com/mgrowth_dev")
  when :production  then DataMapper.setup(:default, "mysql://mmxueche:ASDFghjkl2015@rm-wz93qf9u9x61ute9vo.mysql.rds.aliyuncs.com/mgrowth_production")
end

$redis = Redis.new(:host => "127.0.0.1", :port => 6379)


