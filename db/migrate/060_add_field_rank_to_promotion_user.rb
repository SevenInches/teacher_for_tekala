migration 60, :add_field_rank_to_promotion_user do
  up do
    modify_table :promotion_users do
      add_column :rank, Integer
    end
  end

  down do
    modify_table :promotion_users do
      drop_column :rank
    end
  end
end
