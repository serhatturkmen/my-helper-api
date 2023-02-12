require 'rails_helper'

RSpec.describe('Query', type: :request) do
  def query_string(query)
    %|
    query {
      searchWantToItem(query: "#{query}") {
        name
        description
        url
        position
      }
    }
    |
  end

  let(:user) { create(:user) }
  let(:want_to_category) { create(:want_to_category, user: user) }
  let(:want_to_item) { create(:want_to_item, name: 'Test', want_to_category: want_to_category) }
  let(:want_to_item_2) { create(:want_to_item, name: 'Deneme', want_to_category: want_to_category) }
  let(:want_to_item_3) { create(:want_to_item, name: 'Deneme-2', want_to_category: want_to_category) }

  let(:headers) do
    { 'Api-Token' => user.token }
  end

  before do
    want_to_item
    want_to_item_2
    want_to_item_3
  end

  def request(query)
    post('/graphql', params: { query: query_string(query) }, headers: headers)
  end

  it 'success' do
    search_query = 'Test'

    request(search_query)
    json = JSON.parse(response.body)

    expect(json['data']['searchWantToItem'].count).to(eq(1))
    expect(json['data']['searchWantToItem'].first['name']).to(eq(want_to_item.name))
  end

  it 'return two items' do
    search_query = 'Deneme'

    request(search_query)
    json = JSON.parse(response.body)

    expect(json['data']['searchWantToItem'].count).to(eq(2))
    expect(json['data']['searchWantToItem'].pluck('name')).to(match_array([want_to_item_2.name, want_to_item_3.name]))
  end

  it 'fail not found want to item' do
    request('')
    json = JSON.parse(response.body)

    expect(json['errors'][0]['message']).to(eq("Query cannot be blank"))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request(want_to_category.id)
    json = JSON.parse(response.body)

    expect(json['errors']).to(be)
  end
end
