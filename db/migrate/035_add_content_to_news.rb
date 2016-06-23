migration 35, :add_content_to_news do
  up do
    modify_table :news do
      add_column :content, DataMapper::Property::Text
    end
  end

  down do
    modify_table :news do
      drop_column :content
    end
  end
end
