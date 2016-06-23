migration 42, :create_user_coupons do
  up do
    create_table :user_coupons do
      column :id, Integer, :serial => true
      column :coupon_id, DataMapper::Property::Integer
      column :user_id, DataMapper::Property::Integer
      column :status, DataMapper::Property::Integer
      column :code, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :user_coupons
  end
end
