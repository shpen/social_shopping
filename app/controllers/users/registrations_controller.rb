class Users::RegistrationsController < Devise::RegistrationsController
  protected

    def after_sign_up_path_for(resource)
      if resource.provider == 'facebook'
        facebook_friends_url
      else
        signed_in_root_path(resource)
      end
    end

    def after_update_path_for(resource)
      signed_in_root_path(resource)
    end
end