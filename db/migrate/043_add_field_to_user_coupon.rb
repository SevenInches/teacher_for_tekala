migration 43, :add_field_to_user_coupon do
  up do
    modify_table :user_coupons do
      add_column :created_at, DateTime
      add_column :updated_at, DateTime
    end
  end

  down do
    modify_table :user_coupons do
      drop_column :created_at
    drop_column :updated_at
    end
  end
end
