migration 27, :create_orders do
  up do
    create_table :orders do
      column :id, Integer, :serial => true
      column :user_id, DataMapper::Property::Integer
      column :order_no, DataMapper::Property::String, :length => 255
      # column :phone, DataMapper::Property::String, :length => 255
      # column :address, DataMapper::Property::String, :length => 255
      # column :channel, DataMapper::Property::String, :length => 255
      # column :currency, DataMapper::Property::String, :length => 255
      # column :client_ip, DataMapper::Property::String, :length => 255
      # column :subjet, DataMapper::Property::String, :length => 255
      # column :body, DataMapper::Property::String, :length => 255
      column :amount, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :orders
  end
end
