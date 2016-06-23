# -*- encoding : utf-8 -*-
migration 3, :create_books do
  up do
    create_table :books do
      column :id, Integer, :serial => true
      column :user_id, DataMapper::Property::Integer
      column :exam_name, DataMapper::Property::String, :length => 255
      column :exam_time, DataMapper::Property::DateTime
      column :book_result, DataMapper::Property::Integer
      column :book_type, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :books
  end
end
