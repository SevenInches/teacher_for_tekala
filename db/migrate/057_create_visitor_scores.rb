migration 57, :create_visitor_scores do
  up do
    create_table :visitor_scores do
      column :id, Integer, :serial => true
      column :visitor_id, DataMapper::Property::Integer
      column :score, DataMapper::Property::Integer
      column :wechat_name, DataMapper::Property::String, :length => 255
      column :wechat_unionid, DataMapper::Property::String, :length => 255
      column :sex, DataMapper::Property::Integer
      column :city, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :visitor_scores
  end
end
