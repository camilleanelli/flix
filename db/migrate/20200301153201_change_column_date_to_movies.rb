class ChangeColumnDateToMovies < ActiveRecord::Migration[6.0]
  def change
    rename_column :movies, :date, :released_on
    change_column :movies, :released_on, :date
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
