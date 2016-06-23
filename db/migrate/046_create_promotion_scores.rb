migration 46, :create_promotion_scores do
  up do
    create_table :promotion_scores do
      column :id, Integer, :serial => true
      column :user_id, DataMapper::Property::String, :length => 255
      column :type, DataMapper::Property::Integer
      column :score, DataMapper::Property::Integer
      column :wechat_avatar, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :promotion_scores
  end
end
