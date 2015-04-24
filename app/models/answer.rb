class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true

  validate :user_differs_from_question_user

  # We cannot reply to a question that we asked ourselves
  def user_differs_from_question_user
    if question.user_id == user_id
      errors[:base] << "You cannot answer your own question"
    end
  end
end
