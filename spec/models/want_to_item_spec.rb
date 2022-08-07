require 'rails_helper'

RSpec.describe WantToItem, type: :model do
  it { is_expected.to belong_to(:want_to_category) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:want_to_category_id) }
end

# == Schema Information
#
# Table name: want_to_items
#
#  id                  :bigint           not null, primary key
#  active              :boolean          default(TRUE)
#  description         :string
#  name                :string
#  position            :integer
#  url                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  want_to_category_id :bigint           not null
#
# Indexes
#
#  index_want_to_items_on_want_to_category_id  (want_to_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (want_to_category_id => want_to_categories.id)
#
