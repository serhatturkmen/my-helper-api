require 'rails_helper'

RSpec.describe('Query', type: :request) do
  def query_string(id)
    %|
    query {
      wantToCategory(id: "#{id}") {
        name
        description
        active
        color
        position
        count
      }
    }
    |
  end

  let(:user) { create(:user) }
  let(:want_to_category) { create(:want_to_category, user: user) }
  let(:want_to_category_2) { create(:want_to_category, user: create(:user)) }

  let(:headers) do
    { 'Api-Token' => user.token }
  end

  before do
    user
    want_to_category
    want_to_category_2
  end

  def request(id)
    post('/graphql', params: { query: query_string(id) }, headers: headers)
  end

  it 'success' do
    create(:want_to_item, want_to_category: want_to_category)

    request(want_to_category.id)
    json = JSON.parse(response.body)

    expect(json['data']['wantToCategory']['name']).to(eq(want_to_category.name))
    expect(json['data']['wantToCategory']['count']).to(eq(1))
  end

  it 'fail not found want to item' do
    request(want_to_category_2.id)
    json = JSON.parse(response.body)

    expect(json['errors'][0]['message']).to(eq("Could not find WantToCategory with id #{want_to_category_2.id}"))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request(want_to_category.id)
    json = JSON.parse(response.body)

    expect(json['errors']).to(be)
  end
end
