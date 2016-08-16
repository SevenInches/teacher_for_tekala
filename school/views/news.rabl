node(:status) { 'success' }
node(:total) { @total }
child(@news => :data) {
  attributes :id, :title, :tagline, :content, :view_count, :created_at
  }