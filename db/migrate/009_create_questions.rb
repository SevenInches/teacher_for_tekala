# -*- encoding : utf-8 -*-
migration 9, :create_questions do
  up do
    create_table :questions do
      column :id, Integer, :serial => true
      column :title, DataMapper::Property::String, :length => 255
      column :content, DataMapper::Property::String, :length => 255
      column :tag, DataMapper::Property::Text
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :questions
  end
end
