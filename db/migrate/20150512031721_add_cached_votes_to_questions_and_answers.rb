class AddCachedVotesToQuestionsAndAnswers < ActiveRecord::Migration
  def change
    add_column :questions, :cached_votes_total, :integer, :default => 0
    add_column :questions, :cached_votes_score, :integer, :default => 0
    add_column :questions, :cached_votes_up, :integer, :default => 0
    add_column :questions, :cached_votes_down, :integer, :default => 0
    add_index  :questions, :cached_votes_total
    add_index  :questions, :cached_votes_score
    add_index  :questions, :cached_votes_up
    add_index  :questions, :cached_votes_down

    add_column :answers, :cached_votes_total, :integer, :default => 0
    add_column :answers, :cached_votes_score, :integer, :default => 0
    add_column :answers, :cached_votes_up, :integer, :default => 0
    add_column :answers, :cached_votes_down, :integer, :default => 0
    add_index  :answers, :cached_votes_total
    add_index  :answers, :cached_votes_score
    add_index  :answers, :cached_votes_up
    add_index  :answers, :cached_votes_down
  end
end
