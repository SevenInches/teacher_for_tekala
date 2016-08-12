node(:status) { 'success' }
node(:total) { @total }
child(@orders => :data){
  attributes :id, :order_no, :note, :status, :status_word, :created_at, :book_time, :quantity, :book_time

  attribute :pay_at,      :if => lambda { |val| val.pay_at.present? }
  attribute :done_at,     :if => lambda { |val| val.done_at.present? }
  attribute :cancel_at,   :if => lambda { |val| val.cancel_at.present? }
  attribute :note,        :if => lambda { |val| val.note.present? }

  child(:teacher) {
    attributes :id, :mobile, :name, :avatar_url, :avatar_thumb_url, :rate
  }
}
