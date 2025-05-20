class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string   :title
      t.text     :notes
      t.datetime :due_date
      t.datetime :completed_at
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :listable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
