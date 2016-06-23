migration 86, :add_field_to_teacher_audit do
  up do
    modify_table :teacher_audits do
      add_column :app_download, Integer
    end
  end

  down do
    modify_table :teacher_audits do
      drop_column :app_download
    end
  end
end
