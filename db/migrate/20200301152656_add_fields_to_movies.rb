class AddFieldsToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :description, :string
    add_column :movies, :date, :datetime
  end
end
