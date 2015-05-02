class AddLinkToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :link, :string
  end
end
