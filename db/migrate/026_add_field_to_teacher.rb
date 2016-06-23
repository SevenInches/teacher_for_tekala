migration 26, :add_field_to_teacher do
  up do
    modify_table :teachers do
      add_column :price, Integer
    add_column :promo_price, Integer
    end
  end

  down do
    modify_table :teachers do
      drop_column :price
    drop_column :promo_price
    end
  end
end
