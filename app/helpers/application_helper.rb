module ApplicationHelper
  def sort_by(records, sort)
    case sort
    when 'newest'
      records.order(created_at: :desc)
    when 'oldest'
      records.order(created_at: :asc)
    when 'lowest'
      records.order(cached_votes_score: :asc)
    else
      records.order(cached_votes_score: :desc)
    end
  end

  # Devise helpers so I can use devise partials
  def resource_name
    :user
  end

  def resource_class
    User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
