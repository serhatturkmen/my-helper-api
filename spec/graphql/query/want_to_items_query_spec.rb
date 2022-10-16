require 'rails_helper'

RSpec.describe('Query', type: :request) do
  def query_string(category_id)
    %|
    query {
      wantToItems(wantToCategoryId: "#{category_id}") {
        name
        description
        url
        position
		  wantToCategory {
			  id
			  name
		  }
      }
    }
    |
  end

  let(:user) { create(:user) }
  let(:want_to_category) { create(:want_to_category, user: user) }
  let(:want_to_item) { create(:want_to_item, want_to_category: want_to_category) }
  let(:want_to_item_2) { create(:want_to_item, want_to_category: want_to_category) }

  let(:headers) do
    { 'Api-Token' => user.token }
  end

  before do
    want_to_item
    want_to_item_2
  end

  def request(want_to_category_id)
    post('/graphql', params: { query: query_string(want_to_category_id) }, headers: headers)
  end

  it 'success' do
    request(want_to_category.id)
    json = JSON.parse(response.body)

    expect(json['data']['wantToItems'].count).to(eq(2))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request(want_to_category.id)
    json = JSON.parse(response.body)

    expect(json['errors']).to(be)
  end
end

