class User < ActiveRecord::Base
  has_many :questions
  has_many :answers

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  acts_as_tagger
  acts_as_voter
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :login

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  # Get all tags for questions from this user
  def get_question_tags
    Question.get_tags_from_users(self)
  end

  # Get all tags for answers from this user
  def get_answer_tags
    ActsAsTaggableOn::Tagging.includes(:tag).where(taggable_type: Question.name, taggable: get_answered_questions).map { |tagging| tagging.tag }.uniq
  end

  # Get questions from this user for a specific tag
  def get_questions_by_tag(tag)
    if tag.nil?
      questions
    else
      Question.tagged_with(tag, owned_by: self)
    end
  end

  # Get answers from this user for a specific tag
  def get_answers_by_tag(tag)
    if tag.nil?
      answers
    else
      answers.where(question: get_answered_questions(tag))
    end
  end

  # Get all questions the user has answered
  def get_answered_questions(tag = nil)
    if tag.nil?
      Question.joins(:answers).where(answers: { id: answers }).uniq
    else
      Question.tagged_with(tag).joins(:answers).where(answers: { id: answers }).uniq
    end
  end


  ### DEVISE ###

  # Override authentication to use email or username
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.username = data["name"] if user.username.blank?
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
