class Users::RegistrationsController < Devise::RegistrationsController
  protected

    def after_sign_up_path_for(resource)
      if resource.provider == 'facebook'
        facebook_friends_url
      else
        super
      end
    end
end