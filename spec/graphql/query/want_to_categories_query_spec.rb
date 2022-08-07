require 'rails_helper'

RSpec.describe('Query', type: :request) do
  let(:query_string) do
    %|
    query {
      wantToCategories {
        name
        description
        active
        color
        position
      }
    }
    |
  end

  let(:user) { create(:user) }
  let(:want_to_category) { create(:want_to_category, user: user) }
  let(:want_to_category_2) { create(:want_to_category, user: user) }
  let(:want_to_category_3) { create(:want_to_category, user: create(:user)) }

  let(:headers) do
    { 'Api-Token' => user.token }
  end

  before do
    user
    want_to_category
    want_to_category_2
    want_to_category_3
  end

  def request
    post('/graphql', params: { query: query_string }, headers: headers)
  end

  it 'success' do
    request
    json = JSON.parse(response.body)

    expect(json['data']['wantToCategories'].count).to(eq(2))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request
    json = JSON.parse(response.body)

    expect(json['errors']).to(be)
  end
end
