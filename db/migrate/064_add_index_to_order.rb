migration 64, :add_index_to_order do
  up do
  	create_index :orders, :order_no
  	create_index :orders, :order_no, :user_id
  	create_index :orders, :status,   :user_id
  end

  down do
  end
end
