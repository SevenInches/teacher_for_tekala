migration 15, :create_news do
  up do
    create_table :news do
      column :id, Integer, :serial => true
      column :title, DataMapper::Property::String, :length => 255
      column :tagline, DataMapper::Property::Text
      column :photo, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :news
  end
end
