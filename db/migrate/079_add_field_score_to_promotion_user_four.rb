migration 79, :add_field_score_to_promotion_user_four do
  up do
    modify_table :promotion_user_fours do
      add_column :score, Integer
    end
  end

  down do
    modify_table :promotion_user_fours do
      drop_column :score
    end
  end
end
