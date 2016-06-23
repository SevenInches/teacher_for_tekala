migration 22, :create_teacher_comments do
  up do
    create_table :teacher_comments do
      column :id, Integer, :serial => true
      column :user_id, DataMapper::Property::Integer
      column :teacher_id, DataMapper::Property::Integer
      column :rate, DataMapper::Property::Integer
      column :content, DataMapper::Property::Text
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :teacher_comments
  end
end
