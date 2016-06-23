migration 19, :create_exam_lists do
  up do
    create_table :exam_lists do
      column :id, Integer, :serial => true
      column :exam_time, DataMapper::Property::DateTime
      column :num, DataMapper::Property::String, :length => 255
      column :id_card, DataMapper::Property::String, :length => 255
      column :section, DataMapper::Property::String, :length => 255
      column :name, DataMapper::Property::String, :length => 255
      column :drive_school, DataMapper::Property::String, :length => 255
      column :register, DataMapper::Property::DateTime
      column :allow_exam, DataMapper::Property::DateTime
      column :wait_value, DataMapper::Property::Integer
      column :exam_count, DataMapper::Property::Integer
      column :car_type, DataMapper::Property::String, :length => 255
      column :section_name, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :exam_lists
  end
end
