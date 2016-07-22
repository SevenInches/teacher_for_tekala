node(:status) { 'success' }
child(@shop => :data){
      attributes :id, :name, :address, :contact_phone, :logo
      node(:consultant_count) {@consultant_count}
      node(:student_count) {@student_count}
      node(:consultant_chu_student) {@consultant_chu_student}
}