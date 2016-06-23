migration 67, :add_field_order_id_to_user_coupon do
  up do
    modify_table :user_coupons do
      add_column :order_id, Integer
    end
  end

  down do
    modify_table :user_coupons do
      drop_column :order_id
    end
  end
end
