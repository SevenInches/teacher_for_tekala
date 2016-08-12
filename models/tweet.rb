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

  has n, :tweet_photos, :constraint => :destroy

  has n, :tweet_comments, :constraint => :destroy

  has n, :tweet_likes, :constraint => :destroy


  def photos
    tweet_photos.map(&:url).map{ |val| val.present? ? CustomConfig::QINIUURL + val : '' };
  end

  def comment_count
    tweet_comments.count
  end

  def photo_count
    tweet_photos.count
  end

  def like_count
    tweet_likes.count
  end

end
