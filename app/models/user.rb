require 'open-uri'

class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :comments

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  acts_as_tagger
  acts_as_voter
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :login

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  with_options if: 'provider == "facebook"' do
    validates :uid, presence: true
    validates :token, presence: true
    validates :expiration, presence: true
    validates :name, presence: true
  end

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

  def query_facebook_for_friends
    friend_data = JSON.parse(open("https://graph.facebook.com/v2.3/#{uid}/friends?access_token=#{token}").read)["data"]
    uids = []
    friend_data.each { |friend| uids << friend["id"] }
    users = User.where(uid: uids)
    user_ids = users.pluck(:id)

    # Update friendships and requests to reflect Facebook connections
    Friendship.where(user: self, friend: user_ids).update_all(facebook: true)
    Friendship.where(user: user_ids, friend: self).update_all(facebook: true)
    FriendRequest.where(user: self, friend: user_ids).update_all(facebook: true)
    FriendRequest.where(user: user_ids, friend: self).update_all(facebook: true)

    users
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
    where(provider: auth.provider, uid: auth.uid).first_or_create
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.name = data["name"] if user.name.blank?
        user.email = data["email"] if user.email.blank?

        user.password = Devise.friendly_token[0,20] if user.encrypted_password.blank?

        user.provider = session["devise.facebook_data"]["provider"] if user.provider.blank?
        user.uid = session["devise.facebook_data"]["uid"] if user.uid.blank?

        user.token = session["devise.facebook_data"]["credentials"]["token"] if user.token.blank?
        user.expiration = Time.at(session["devise.facebook_data"]["credentials"]["expires_at"].to_i).to_datetime if user.expiration.blank?
      end
    end
  end
end
