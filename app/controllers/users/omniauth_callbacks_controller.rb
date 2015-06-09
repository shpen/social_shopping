#require 'open-uri'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
  #redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email,user_friends"

=begin
    permissions = JSON.parse(open("https://graph.facebook.com/v2.3/#{request.env['omniauth.auth']['uid']}/permissions?access_token=#{request.env['omniauth.auth']['credentials']['token']}").read)
    friends = false
    permissions['data'].each do |perm|
      if perm['permission'] == 'user_friends' && perm['status'] == 'granted'
        friends = true
      end
    end

    # Ask again for email/friends
    if !friends || request.env["omniauth.auth"].info.email.blank?
      redirect_to facebook_permissions_url
      return
    end
=end

    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end