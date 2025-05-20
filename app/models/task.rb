# == Schema Information
#
# Table name: tasks
#
#  id            :bigint           not null, primary key
#  completed_at  :datetime
#  due_date      :datetime
#  listable_type :string           not null
#  notes         :text
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :bigint           not null
#  listable_id   :bigint           not null
#
# Indexes
#
#  index_tasks_on_creator_id  (creator_id)
#  index_tasks_on_listable    (listable_type,listable_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
class Task < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :creator_id, inverse_of: :created_tasks
  belongs_to :listable, polymorphic: true, inverse_of: :tasks

  validates :title, presence: true
end
