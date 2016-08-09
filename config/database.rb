DataMapper.logger = logger
DataMapper::Property::String.length(255)
require "redis"

case Padrino.env
  when :development then
    DataMapper.setup(:default, "mysql://mmxueche:ASDFghjkl2015@rm-wz93qf9u9x61ute9vo.mysql.rds.aliyuncs.com/mgrowth_dev")
    $redis = Redis.new(:host => "127.0.0.1", :port => 6379)
  when :production  then
    DataMapper.setup(:default, "mysql://mmxueche:ASDFghjkl2015@rm-wz93qf9u9x61ute9vo.mysql.rds.aliyuncs.com/mgrowth_production")
    $redis = Redis.new(:host => "112.74.21.225", :port => 6379)
end


