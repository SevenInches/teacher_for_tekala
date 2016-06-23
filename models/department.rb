# -*- encoding : utf-8 -*-
class Department
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :value, String
  property :name, String
  
end
