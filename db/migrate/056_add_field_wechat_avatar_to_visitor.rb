migration 56, :add_field_wechat_avatar_to_visitor do
  up do
    modify_table :visitors do
      add_column :wechat_avatar, String
      add_column :score, Integer
      add_column :created_at, DateTime
    end
  end

  down do
    modify_table :visitors do
      drop_column :wechat_avatar
      drop_column :score
      drop_column :created_at
    end
  end
end
