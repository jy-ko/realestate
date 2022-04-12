class RemoveUrlfromAccounts < ActiveRecord::Migration[6.1]
  def change
    remove_column :accounts, :url
  end
end
