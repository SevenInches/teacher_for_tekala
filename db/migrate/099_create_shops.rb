# -*- encoding : utf-8 -*-
migration 99, :create_shops do
  up do
    create_table :shops do
      column :id, Integer, :serial => true
      column :crypted_password, DataMapper::Property::String, :length => 255 
      column :address, DataMapper::Property::String, :length => 255
      column :name, DataMapper::Property::String, :length => 255
      column :contact_phone, DataMapper::Property::String, :length => 255
      column :profile, DataMapper::Property::Text
      column :logo, DataMapper::Property::String, :length => 255     #logo
      column :config, DataMapper::Property::Text     #配置
      column :student_count, DataMapper::Property::Integer # 招生人数
      column :consultant_count, DataMapper::Property::Integer # 咨询人数

      column :created_at, DataMapper::Property::DateTime
      column :updated_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :shops
  end
end