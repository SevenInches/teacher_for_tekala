migration 16, :create_sys_configs do
  up do
    create_table :sys_configs do
      column :id, Integer, :serial => true
      column :cover_url, DataMapper::Property::String, :length => 255
      column :show_ad, DataMapper::Property::Integer
      column :url, DataMapper::Property::String, :length => 255
      column :force, DataMapper::Property::Integer
      column :version, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :sys_configs
  end
end
