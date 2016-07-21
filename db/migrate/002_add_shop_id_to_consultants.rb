migration 2, :add_shop_id_to_consultants do
  up do
    modify_table :consultants do
      add_column :shop_id, DataMapper::Property::Integer
    end
  end

  down do
    modify_table :consultants do
    	drop_column :shop_id
    end
  end
end