migration 32, :add_qq_to_teachers do
  up do
    modify_table :teachers do
      add_column :qq, String
      add_column :car_lincese_photo, String
      add_column :livecard_front_photo, String
      add_column :livecard_back_photo, String
      add_column :lincese_front_photo, String
      add_column :lincese_back_photo, String
    end
  end

  down do
    add_column :qq
    add_column :car_lincese_photo
    add_column :livecard_front_photo
    add_column :livecard_back_photo
    add_column :lincese_front_photo
    add_column :lincese_back_photo
  end
end
