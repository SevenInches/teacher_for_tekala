# -*- encoding : utf-8 -*-
migration 7, :create_tweets do
  up do
    create_table :tweets do
      column :id, Integer, :serial => true
      column :user_id, DataMapper::Property::Integer
      column :content, DataMapper::Property::Text
      column :photo, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :tweets
  end
end
