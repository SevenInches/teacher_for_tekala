migration 1, :add_shop_id_to_students do
  up do
    modify_table :students do
    	add_column :shop_id, DataMapper::Property::Integer
    end
  end

  down do
    modify_table :students do
    	drop_column :shop_id
    end
  end
end