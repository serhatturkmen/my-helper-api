require 'rails_helper'

RSpec.describe('Query', type: :request) do
  def query_string(query)
    %|
    query {
      searchWantToCategories(query: "#{query}") {
        name
      }
    }
    |
  end

  let(:user) { create(:user) }
  let(:want_to_category) { create(:want_to_category, name: 'Test', user: user) }
  let(:want_to_category_2) { create(:want_to_category, name: 'Deneme', user: user) }
  let(:want_to_category_3) { create(:want_to_category, name: 'Deneme-2', user: user) }
  let(:want_to_category_4) { create(:want_to_category, name: 'Test-2', user: create(:user)) }

  let(:headers) do
    { 'Api-Token' => user.token }
  end

  before do
    want_to_category
    want_to_category_2
    want_to_category_3
    want_to_category_4
  end

  def request(query)
    post('/graphql', params: { query: query_string(query) }, headers: headers)
  end

  it 'success' do
    search_query = 'Test'

    request(search_query)
    json = JSON.parse(response.body)

    expect(json['data']['searchWantToCategories'].count).to(eq(1))
    expect(json['data']['searchWantToCategories'].first['name']).to(eq(want_to_category.name))
  end

  it 'return two items' do
    search_query = 'Deneme'

    request(search_query)
    json = JSON.parse(response.body)

    expect(json['data']['searchWantToCategories'].count).to(eq(2))
    expect(json['data']['searchWantToCategories'].pluck('name')).to(match_array([want_to_category_2.name, want_to_category_3.name]))
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
