migration 31, :create_sellers do
  up do
    create_table :sellers do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :crypted_password, DataMapper::Property::String, :length => 255
      column :mobile, DataMapper::Property::String, :length => 255
      column :wechat, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :sellers
  end
end
