class InterviewQuestion < ActiveRecord::Base
  def submitted?
    !!submitted_flag
  end  

  def validate_submit
    if can_submit?
      return true
    else
      errors.add(:base, "Please fill in all the fields before submitting.")
      return false
    end
  end

  def validate_create
    if can_create?
      return true
    else
      errors.add(:base, "Please fill in the question before submitting.")
      return false
    end
  end

  private 

  def can_submit?
    submit_required_params.all? {|param| self.send(param).present? }
  end

  def can_create?
    create_required_params.all? {|param| self.send(param).present? }
  end

  def create_required_params
    [:question_text, :unique_id]
  end

  def submit_required_params
    [:name, :email, :response_language, :response_text].concat(create_required_params) 
  end
end
