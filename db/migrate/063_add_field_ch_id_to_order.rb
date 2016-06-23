migration 63, :add_field_ch_id_to_order do
  up do
    modify_table :orders do
      add_column :ch_id, String
    end
  end

  down do
    modify_table :orders do
      drop_column :ch_id
    end
  end
end
