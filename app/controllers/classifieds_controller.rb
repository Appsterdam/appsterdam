class ClassifiedsController < ApplicationController
  allow_access :authenticated

  def create
    @authenticated.classifieds.create(params[:classified])
    redirect_to classifieds_url
  end
end
