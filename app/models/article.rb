# encoding: UTF-8

class Article < ActiveRecord::Base
  belongs_to :member

  validates :title, :presence => true
  validates :body, :presence => true

  define_index do
    has :id

    indexes :title
  end

  def self.create_with_attributes(attributes)
    article = Article.new
    article.twitter_id = attributes['twitter_id']
    article.title = attributes['title']
    article.body = attributes['body']
    article.save
    article
  end

  def publish
    self.published = true
  end

end
