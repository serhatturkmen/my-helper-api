class WantToCategory < ApplicationRecord
  belongs_to :user
  has_many :want_to_items, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }

  def count
    want_to_items.active.count
  end
end

# == Schema Information
#
# Table name: want_to_categories
#
#  id          :bigint           not null, primary key
#  active      :boolean          default(TRUE)
#  color       :string
#  description :string
#  name        :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_want_to_categories_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
