class RemoveLinkFromAnswers < ActiveRecord::Migration
  def change
  	remove_column :answers, :link
  end
end
