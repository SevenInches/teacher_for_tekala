migration 92, :add_field_vip_to_orders do
  up do
    modify_table :orders do
      add_column :vip, Integer
    end
  end

  down do
    modify_table :orders do
      drop_column :vip
    end
  end
end
