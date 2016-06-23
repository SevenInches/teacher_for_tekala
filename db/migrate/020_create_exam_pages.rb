migration 20, :create_exam_pages do
  up do
    create_table :exam_pages do
      column :id, Integer, :serial => true
      column :page, DataMapper::Property::Integer
      column :created_at, DataMapper::Property::DateTime
      column :total_page, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :exam_pages
  end
end
