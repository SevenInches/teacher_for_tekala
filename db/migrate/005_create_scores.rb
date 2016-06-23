# -*- encoding : utf-8 -*-
migration 5, :create_scores do
  up do
    create_table :scores do
      column :id, Integer, :serial => true
      column :user_id, DataMapper::Property::Integer
      column :score, DataMapper::Property::Integer
      column :type, DataMapper::Property::Integer
      column :note, DataMapper::Property::Text
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :scores
  end
end
