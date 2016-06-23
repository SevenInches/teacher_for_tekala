migration 39, :add_field_to_teacher_bank_card_photo do
  up do
    modify_table :teachers do
      add_column :bank_card_photo, String
    end
  end

  down do
    modify_table :teachers do
      drop_column :bank_card_photo
    end
  end
end
