# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :groups, foreign_key: :creator_id, dependent: :nullify, inverse_of: :creator

  has_many :group_memberships, dependent: :destroy, inverse_of: :user
  has_many :groups_joined, through: :group_memberships, source: :group

  has_many :created_tasks, class_name: "Task", foreign_key: :creator_id, dependent: :nullify, inverse_of: :creator
  has_many :tasks, as: :listable, dependent: :destroy, inverse_of: :listable

  validates :first_name, presence: true
  validates :last_name, presence: true
end
