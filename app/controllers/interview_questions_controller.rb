class InterviewQuestionsController < ApplicationController
  before_action :load_and_verify_interview_question, only: [:edit, :update, :show]
  before_action :verify_submitted, only: [:edit, :update]

  def new
    @interview_question = InterviewQuestion.new
  end

  def create
    @interview_question = InterviewQuestion.new(new_interview_question_params)
    @interview_question.unique_id = SecureRandom.hex
    if @interview_question.validate_create && 
        @interview_question.save
      flash[:notice] = "Interview question created correctly, please share it with interviewee!"
      redirect_to edit_interview_question_path(@interview_question.unique_id)
    else
      flash[:error] = "There was a problem creating the question, please try again. " + @interview_question.errors[:base].first
      render :new
    end
  end

  def show
    unless @interview_question.submitted? 
      flash[:error] = "This interview question has not been submitted yet!"
      redirect_to edit_interview_question_path(@interview_question.unique_id)
    end
  end

  def edit
  end

  def update
    @interview_question.assign_attributes(interview_response_params.merge({submitted_flag: true}))
    if @interview_question.validate_submit && @interview_question.save
      flash[:notice] = "Response submitted correctly, thank you!"
      redirect_to interview_question_path(@interview_question.unique_id)
    else
      flash[:error] = "There was a problem submitting your reponse, please try again. " + @interview_question.errors[:base].first
      render :edit
    end
  end

  private 

  def new_interview_question_params
    params.require(:interview_question).permit(:name, :email, :response_language, :response_text, :question_text)
  end

  def interview_response_params
    params.require(:interview_question).permit(:name, :email, :response_language, :response_text)
  end

  def verify_submitted
    if @interview_question.submitted? 
      redirect_to interview_question_path(@interview_question.unique_id)
      flash[:notice] = "This question has already been submitted."
    end
  end

  def load_and_verify_interview_question
    @interview_question = InterviewQuestion.find_by_unique_id(params[:id])

    unless @interview_question.present? 
      flash[:error] = "This question does not exist. Create a new one if you wish"
      redirect_to new_interview_question_path
    end
  end
end
