class ArticlesController < ApplicationController

  allow_access(:authenticated, :only => [:index, :new, :create])
  allow_access(:authenticated, :only => [:edit, :update, :destroy]) { !find_article.nil? }
  allow_access(:all, :only => :index) { !my_articles? }
  allow_access(:all, :only => :show) { !find_article.nil? }

  use_tinymce :all

  def index
    if my_articles?
      fetch_my_articles
    else
      fetch_all_articles
    end
    render :index
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
    @article.destroy
    redirect_to articles_url
  end

  def update
    if @article.update_attributes(params[:article])
      redirect_to articles_url
    else
      render :edit
    end
  end

  def edit
    @article = @authenticated.articles.find_by_id(params[:id])
  end

  def fetch_my_articles
    @articles = @authenticated.articles
  end

  def fetch_all_articles
    @articles = Article.all
  end

  def find_article
    @article = @authenticated.articles.find_by_id(params[:id])
  end

  def my_articles?
    params[:show] == :mine
  end
  
  def show
  end
end
