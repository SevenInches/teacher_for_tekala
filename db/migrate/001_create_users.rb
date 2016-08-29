# -*- encoding : utf-8 -*-
migration 1, :create_users do
  up do
    create_table :users do
      column :id, Integer, :serial => true
      column :id_card, DataMapper::Property::String, :length => 255
      column :password, DataMapper::Property::String, :length => 255 
      column :crypted_password, DataMapper::Property::String, :length => 255
      column :name, DataMapper::Property::String, :length => 255
      column :mobile, DataMapper::Property::String, :length => 255
      column :city, DataMapper::Property::String, :length => 255
      column :started_at, DataMapper::Property::DateTime
      column :sex, DataMapper::Property::Integer
      column :avatar, DataMapper::Property::String
      column :score, DataMapper::Property::Integer
      column :lavel, DataMapper::Property::Integer
      column :school, DataMapper::Property::String
      column :birthday, DataMapper::Property::Date
      column :star, DataMapper::Property::String
      column :last_login, DataMapper::Property::DateTime

      column :created_at, DataMapper::Property::DateTime
      column :updated_at, DataMapper::Property::DateTime

      column :book_password, DataMapper::Property::String
      column :timeline, DataMapper::Property::Text
      column :status_flag, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :users
  end
end
