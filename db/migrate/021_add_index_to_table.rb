migration 21, :add_index_to_table do
  up do
  	create_index :exam_lists, :num
  	create_index :exam_pages, :total_page, :page
  end

  down do
  end
end
