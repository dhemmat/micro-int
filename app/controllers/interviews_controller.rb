class InterviewsController < ApplicationController
  def show
    @interview = Interview.find_by_unique_id(params[:unique_id])
  end
end
