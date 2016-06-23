migration 48, :create_params_configs do
  up do
    create_table :params_configs do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :value, DataMapper::Property::String, :length => 255
      column :remark, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
      column :updated_at, DataMapper::Property::Time
    end
    create_index :params_configs, :name
  end

  down do
    drop_table :params_configs
  end
end
