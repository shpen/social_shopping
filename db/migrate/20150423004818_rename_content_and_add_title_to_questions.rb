class RenameContentAndAddTitleToQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.rename :content, :description
      t.string :title
    end
  end
end
