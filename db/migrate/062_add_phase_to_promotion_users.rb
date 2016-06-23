migration 62, :add_phase_to_promotion_users do
  up do
    modify_table :promotion_users do
      add_column :phase, Integer
    end
  end

  down do
    modify_table :promotion_users do
      drop_column :phase
    end
  end
end
