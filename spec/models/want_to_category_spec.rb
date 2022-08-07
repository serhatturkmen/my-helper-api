require 'rails_helper'

RSpec.describe WantToCategory, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:want_to_items) }
  it { is_expected.to validate_presence_of(:name) }
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
