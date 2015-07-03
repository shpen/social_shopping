class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable

  acts_as_votable

  validates :question, presence: true
  validates :user, presence: true
  validates :content, presence: true

  validate :user_differs_from_question_user

  # We cannot reply to a question that we asked ourselves
  def user_differs_from_question_user
    if !question.nil? && question.user == user
      errors[:base] << "You cannot answer your own question"
    end
  end
end
