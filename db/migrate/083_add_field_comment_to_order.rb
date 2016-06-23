migration 83, :add_field_comment_to_order do
  up do
    modify_table :orders do
      add_column :comment_status, Integer
    end

    modify_table :teacher_comments do
      add_column :order_id, Integer
    end

  end

  down do
    modify_table :orders do
      drop_column :comment_status
    end

    modify_table :teacher_comments do
      drop_column :order_id 
    end

  end
end
