class CommandsController < ApplicationController
  allow_access :all
  
  def create
    case params[:task]
    when 'index'
      Rails.logger.info("Stopping all index jobs")
      FlyingSphinx::IndexRequest.cancel_jobs
      Rails.logger.info("Starting a new index request")
      request = FlyingSphinx::IndexRequest.new
      request.update_and_index
      Rails.logger.info("Finished indexing (#{request.status_message})")
    end
    head :ok
  end
end
