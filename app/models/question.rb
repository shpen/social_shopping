class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  validates :user, presence: true
  validates :title, presence: true
end
