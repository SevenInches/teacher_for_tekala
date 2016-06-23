migration 77, :add_field_to_promotion_user_four do
  up do
    modify_table :promotion_user_fours do
      add_column :wechat_avatar, String
    add_column :wechat_unionid, String
    end
  end

  down do
    modify_table :promotionuserfours do
      drop_column :wechat_avatar
    drop_column :wechat_unionid
    end
  end
end
