migration 23, :create_comment_photos do
  up do
    create_table :comment_photos do
      column :id, Integer, :serial => true
      column :comment_id, DataMapper::Property::Integer
      column :photo, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :comment_photos
  end
end
