# -*- encoding : utf-8 -*-
class NotificationJob 
  include Sidekiq::Worker
  include Padrino::Helpers
  def perform(order_id)
  	order = Order.get order_id
    JPush.order_remind(order_id) if Order::pay_or_done.include?(order.status)
  end
end