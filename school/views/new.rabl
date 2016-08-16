node(:status) { 'success' }
child(@new => :data) {
  attributes :id, :title, :content, :view_count
  }