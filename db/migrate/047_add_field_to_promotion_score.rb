migration 47, :add_field_to_promotion_score do
  up do
    modify_table :promotion_scores do
      add_column :wechat_name, String
    add_column :wechat_unionid, String
    add_column :sex, Integer
    add_column :city, String
    end
  end

  down do
    modify_table :promotion_scores do
      drop_column :wechat_name
    drop_column :wechat_unionid
    drop_column :sex
    drop_column :city
    end
  end
end
