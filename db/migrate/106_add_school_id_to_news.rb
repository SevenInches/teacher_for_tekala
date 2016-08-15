migration 106, :add_school_id_to_news do
  up do
  	modify_table :news do
  		add_column :school_id, Integer
  	end
  end

  down do
  	modify_table :news do
  		drop_column :school_id
  	end
  end
end