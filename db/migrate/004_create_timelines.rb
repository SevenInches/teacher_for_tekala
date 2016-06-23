# -*- encoding : utf-8 -*-
migration 4, :create_timelines do
  up do
    create_table :timelines do
      column :id, Integer, :serial => true
      column :user_id, DataMapper::Property::Integer
      column :num, DataMapper::Property::Integer
      column :content, DataMapper::Property::String, :length => 255
      column :type, DataMapper::Property::Integer
      column :date, DataMapper::Property::DateTime
      column :detail, DataMapper::Property::Text
      column :note, DataMapper::Property::Text
    end
  end

  down do
    drop_table :timelines
  end
end
