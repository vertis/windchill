class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :url
      t.string :frequency, :defaul => '3m'
      t.datetime :last_notified
      t.datetime :last_checked
      t.integer :fail_count, :default => 0
      t.integer :fail_limit, :default => 3
      t.string :loaded_by
    end
  end
end
