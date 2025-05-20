# == Schema Information
#
# Table name: group_memberships
#
#  id         :bigint           not null, primary key
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_group_memberships_on_group_id  (group_id)
#  index_group_memberships_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class GroupMembership < ApplicationRecord
  belongs_to :user, inverse_of: :group_memberships
  belongs_to :group, inverse_of: :group_memberships
  enum role: { admin: 0, member: 1 }
  validates :role, presence: true
end
