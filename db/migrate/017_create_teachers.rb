migration 17, :create_teachers do
  up do
    create_table :teachers do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :age, DataMapper::Property::Integer
      column :sex, DataMapper::Property::Integer
      column :id_card, DataMapper::Property::String, :length => 255
      column :drive_card, DataMapper::Property::String, :length => 255
      column :teach_card, DataMapper::Property::String, :length => 255
      column :start_drive, DataMapper::Property::DateTime
      column :start_teach, DataMapper::Property::DateTime
      column :skill, DataMapper::Property::String, :length => 255
      column :profile, DataMapper::Property::Text
      column :hometown, DataMapper::Property::String, :length => 255
      column :avatar, DataMapper::Property::String, :length => 255
      column :id_card_photo, DataMapper::Property::String, :length => 255
      column :drive_card_photo, DataMapper::Property::String, :length => 255
      column :teach_card_photo, DataMapper::Property::String, :length => 255
      column :mobile, DataMapper::Property::String, :length => 255
      column :wechat, DataMapper::Property::String, :length => 255
      column :email, DataMapper::Property::String, :length => 255
      column :address, DataMapper::Property::String, :length => 255
      column :remark, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :teachers
  end
end
