migration 58, :add_field_wechat_unionid_to_visitor do
  up do
    modify_table :visitors do
      add_column :wechat_unionid, String
    end
  end

  down do
    modify_table :visitors do
      drop_column :wechat_unionid
    end
  end
end
