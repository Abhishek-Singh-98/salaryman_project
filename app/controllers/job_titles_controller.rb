class JobTitlesController < ApplicationController
  def index
    @job_titles = JobTitle.all
    render json: @job_titles, status: :ok
  end
end