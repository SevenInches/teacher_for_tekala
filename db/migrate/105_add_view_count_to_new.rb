migration 105, :add_view_count_to_new do
  up do
  	modify_table :news do
  		add_column :view_count, Integer
  	end
  end

  down do
  	modify_table :news do
  		drop_column :view_count
  	end
  end
end