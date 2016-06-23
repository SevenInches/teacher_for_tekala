migration 44, :add_field_bank_card_to_teacher do
  up do
    modify_table :teachers do
      add_column :bank_card, String
    end
  end

  down do
    modify_table :teachers do
      drop_column :bank_card
    end
  end
end
