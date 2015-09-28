class MicroInterviewsController < ApplicationController
  before_action :load_and_verify_micro_interview, only: [:edit, :update, :show]
  before_action :verify_submitted, only: [:edit, :update]

  def new
    if params[:id]
      @micro_interview = MicroInterview.find_by_unique_id(params[:id]).dup
    else
      @micro_interview = MicroInterview.new
    end
  end

  def create
    @micro_interview = MicroInterview.new(new_micro_interview_params)
    @micro_interview.unique_id = SecureRandom.hex
    if @micro_interview.validate_create && 
        @micro_interview.save
      flash[:notice] = "Interview question created correctly, please share it with interviewee!"
      redirect_to edit_micro_interview_path(@micro_interview.unique_id)
    else
      flash[:error] = "There was a problem creating the question, please try again. " + @micro_interview.errors[:base].first
      render :new
    end
  end

  def show
    unless @micro_interview.submitted? 
      flash[:error] = "This interview question has not been submitted yet!"
      redirect_to edit_micro_interview_path(@micro_interview.unique_id)
    end
  end

  def edit
  end

  def update
    @micro_interview.assign_attributes(interview_response_params.merge({submitted_flag: true}))
    if @micro_interview.validate_submit && @micro_interview.save
      flash[:notice] = "Response submitted correctly, thank you!"
      redirect_to micro_interview_path(@micro_interview.unique_id)
    else
      flash[:error] = "There was a problem submitting your reponse, please try again. " + @micro_interview.errors[:base].first
      render :edit
    end
  end

  private 

  def new_micro_interview_params
    params.require(:micro_interview).permit(:name, :email, :response_language, :response_text, :question_text)
  end

  def interview_response_params
    params.require(:micro_interview).permit(:name, :email, :response_language, :response_text)
  end

  def verify_submitted
    if @micro_interview.submitted? 
      redirect_to micro_interview_path(@micro_interview.unique_id)
      flash[:notice] = "This question has already been submitted."
    end
  end

  def load_and_verify_micro_interview
    @micro_interview = MicroInterview.find_by_unique_id(params[:id])

    unless @micro_interview.present? 
      flash[:error] = "This question does not exist. Create a new one if you wish"
      redirect_to new_micro_interview_path
    end
  end
end
