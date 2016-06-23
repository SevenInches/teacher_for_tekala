# -*- encoding : utf-8 -*-
class Tweet
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :user_id, Integer
  property :content, Text, :required => true, :lazy => false,
                           :messages =>{:presence  => "密码不能为空" }
                           
  property :photo, String, :auto_validation => false
  property :created_at, DateTime

  mount_uploader :photo, TweetPhoto

  belongs_to :user

  def photo_thumb_url
     photo.thumb.url ? CustomConfig::HOST + photo.thumb.url : ''
  end 

  def photo_url
     photo.url ? CustomConfig::HOST + photo.url : ''
  end 

end
