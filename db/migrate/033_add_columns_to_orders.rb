migration 33, :add_columns_to_orders do
  up do
    modify_table :orders do
      add_column :teacher_id, Integer
      add_column :subject, DataMapper::Property::Text
      add_column :quantity, Integer
      add_column :price, DataMapper::Property::Float
      add_column :note, String
      add_column :device, String
      add_column :pay_at, DataMapper::Property::DateTime
      add_column :done_at, DataMapper::Property::DateTime
      add_column :cancel_at, DataMapper::Property::DateTime
      add_column :status, Integer
    end
  end

  down do
    drop_column :teacher_id
    drop_column :subject
    drop_column :quantity
    drop_column :price
    drop_column :note
    drop_column :device
    drop_column :pay_at
    drop_column :done_at
    drop_column :cancel_at
    drop_column :status
  end
end
