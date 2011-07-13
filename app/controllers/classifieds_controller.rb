class ClassifiedsController < ApplicationController
  allow_access(:authenticated, :only => [:index, :new, :create])
  allow_access(:authenticated, :only => [:edit, :update, :destroy]) { !find_classified.nil? }
  allow_access(:all, :only => :index) { !my_classifieds? } # visitors have no `my classifieds'

  def index
    @classifieds = my_classifieds? ? @authenticated.classifieds : Classified.all
  end

  def new
    @classified = @authenticated.classifieds.build
  end

  def create
    @classified = @authenticated.classifieds.build(params[:classified])
    if @classified.save
      redirect_to classifieds_url
    else
      render :new
    end
  end

  def update
    if @classified.update_attributes(params[:classified])
      redirect_to classifieds_url
    else
      render :edit
    end
  end

  def destroy
    @classified.destroy
    redirect_to classifieds_url
  end

  private

  def my_classifieds?
    params[:show] == :mine
  end

  def find_classified
    @classified = @authenticated.classifieds.find_by_id(params[:id])
  end
end
