class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  acts_as_taggable
  acts_as_votable

  validates :user, presence: true
  validates :title, presence: true
  validates :tag_list, presence: true
end
