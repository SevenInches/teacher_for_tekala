# -*- encoding : utf-8 -*-
migration 12, :create_ads do
  up do
    create_table :ads do
      column :id, Integer, :serial => true
      column :title, DataMapper::Property::String, :length => 255
      column :image, DataMapper::Property::String, :length => 255
      column :value, DataMapper::Property::String, :length => 255
      column :type, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :ads
  end
end
