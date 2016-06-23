migration 34, :add_id_card_back_photo_to_teachers do
  up do
    modify_table :teachers do
      add_column :id_card_back_photo, String
    end
  end

  down do
    modify_table :teachers do
      drop_column :id_card_back_photo
    end
  end
end
