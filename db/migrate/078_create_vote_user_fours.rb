migration 78, :create_vote_user_fours do
  up do
    create_table :vote_user_fours do
      column :id, Integer, :serial => true
      column :wechat_unionid, DataMapper::Property::String, :length => 255
      column :wechat_avatar, DataMapper::Property::String, :length => 255
      column :company_id, DataMapper::Property::Integer
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :vote_user_fours
  end
end
