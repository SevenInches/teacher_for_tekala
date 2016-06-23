migration 98, :create_withdraw_logs do
  up do
    create_table :withdraw_logs do
      column :id, Integer, :serial => true
      column :amounts, DataMapper::Property::Integer
      column :teacher_id, DataMapper::Property::Integer
      column :status, DataMapper::Property::Integer
      column :note, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :withdraw_logs
  end
end
