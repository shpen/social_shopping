class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  attr_accessor :form_saved

  acts_as_taggable
  acts_as_votable

  validates :user, presence: true
  validates :title, presence: true
  validate :tags_exist

  before_save :set_tag_owner

  def tags_exist
    if form_saved && tag_list.empty?
      errors[:tag_list] << "Tags cannot be empty"
    end

    form_saved = false
  end

  def set_tag_owner
    if tag_list_changed?
      set_owner_tag_list_on(user, :tags, tag_list)
      self.tag_list = nil
    end
  end
end
