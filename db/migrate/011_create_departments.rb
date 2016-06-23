# -*- encoding : utf-8 -*-
migration 11, :create_departments do
  up do
    create_table :departments do
      column :id, Integer, :serial => true
      column :value, DataMapper::Property::String, :length => 255
      column :name, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :departments
  end
end
