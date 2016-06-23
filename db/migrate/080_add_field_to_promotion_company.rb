migration 80, :add_field_to_promotion_company do
  up do
    modify_table :promotion_companies do
      add_column :score, Integer
    end
  end

  down do
    modify_table :promotion_companies do
      drop_column :score
    end
  end
end
