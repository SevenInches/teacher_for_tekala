migration 97, :add_a_money_to_teacher do
  up do
    modify_table :teachers do
      add_column :withdraw_money, Integer
    add_column :freeze_money, Integer
    end
  end

  down do
    modify_table :teachers do
      drop_column :withdraw_money
    drop_column :freeze_money
    end
  end
end
