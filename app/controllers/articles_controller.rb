class ArticlesController < ApplicationController

  allow_access(:all) do
    @authenticated = Member.first(:conditions => {:username => 'isutton'})
  end

  def index
    if my_articles?
      my_articles
    else
      all_articles
    end


  end

  def new
    @article = @authenticated.articles.build
  end

  def create
    @article = @authenticated.articles.build(params[:article])
    if @article.save
      redirect_to articles_url
    else
      render :new
    end
  end

  def destroy

  end

  def update
    @article = @authenticated.articles.find_by_id(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to articles_url
    else
      render :edit
    end
  end

  def edit
    @article = @authenticated.articles.find_by_id(params[:id])
  end

  def my_articles
    @articles = @authenticated.articles
  end

  def all_articles
    @articles = Article.all
  end

  def my_articles?
    params[:show] == :mine
  end
end
