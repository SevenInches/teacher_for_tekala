migration 56, :create_sms do
  up do
    create_table :sms do
      column :id, Integer, :serial => true
      column :mobile, DataMapper::Property::String, :length => 255
      column :content, DataMapper::Property::String, :length => 255
      column :account_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :sms
  end
end
