migration 59, :create_weixin_users do
  up do
    create_table :weixin_users do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :sex, DataMapper::Property::Integer
      column :avatar, DataMapper::Property::String, :length => 255
      column :unionid, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :weixin_users
  end
end
