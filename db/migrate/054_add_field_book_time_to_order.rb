migration 54, :add_field_book_time_to_order do
  up do
    modify_table :orders do
      add_column :book_time, DateTime
    add_column :other_book_time, DateTime
    end
  end

  down do
    modify_table :orders do
      drop_column :book_time
    drop_column :other_book_time
    end
  end
end
