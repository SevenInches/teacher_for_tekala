node(:status) { 'success' }
child(@news => :data) {
  attributes :id, :title, :content, :view_count, :photo, :pv, :created_at
  }