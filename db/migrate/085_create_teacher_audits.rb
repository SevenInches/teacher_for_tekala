migration 85, :create_teacher_audits do
  up do
    create_table :teacher_audits do
      column :id, Integer, :serial => true
      column :teacher_id, DataMapper::Property::Integer
      column :photo, DataMapper::Property::Integer
      column :id_card, DataMapper::Property::Integer
      column :bank_card, DataMapper::Property::Integer
      column :mobile, DataMapper::Property::Integer
      column :place_confirm, DataMapper::Property::Integer
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :teacher_audits
  end
end
