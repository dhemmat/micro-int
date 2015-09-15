class CreateInterviewQuestions < ActiveRecord::Migration
  def change
    create_table :interview_questions do |t|
      t.string :unique_id
      t.string :name
      t.string :email
      t.text :question_text
      t.string :response_language
      t.text :response_text
      t.boolean :submitted_flag
      t.timestamps
    end
  end
end
