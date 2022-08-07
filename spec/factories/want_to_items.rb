FactoryBot.define do
  factory :want_to_item do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    position { rand(1..100) }
    want_to_category { create(:want_to_category) }
  end
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
