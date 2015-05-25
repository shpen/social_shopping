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
end
