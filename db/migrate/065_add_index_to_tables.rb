migration 65, :add_index_to_tables do
  up do
  	create_index :users, :mobile
  	create_index :users, :lavel
  	create_index :users, :score
  	create_index :users, :status_flag

  	create_index :comment_photos, :comment_id

  	create_index :promotion_users, :user_id

  	create_index :teachers, :area, :status
  	create_index :teachers, :status
  	create_index :teachers, :area

  	create_index :teacher_comments, :teacher_id

  	create_index :teacher_comments, :user_id

  	create_index :user_coupons, :coupon_id
  	create_index :user_coupons, :status
  	create_index :user_coupons, :user_id




  end

  down do
  end
end
