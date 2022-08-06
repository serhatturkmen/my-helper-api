FactoryBot.define do
  factory :want_to_category do
    name { "MyString" }
    description { "MyString" }
    color { "MyString" }
    position { "MyString" }
    active { false }
    user { nil }
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
