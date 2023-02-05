require 'rails_helper'

RSpec.describe('Query', type: :request) do
  def query_string
    %|
    query {
      passiveWantToItems {
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
  let(:want_to_item) { create(:want_to_item, active: false, want_to_category: want_to_category) }
  let(:want_to_item_2) { create(:want_to_item, want_to_category: create(:want_to_category, user: create(:user))) }

  let(:headers) do
    { 'Api-Token' => user.token }
  end

  before do
    want_to_item
    want_to_item_2
  end

  def request
    post('/graphql', params: { query: query_string }, headers: headers)
  end

  it 'success' do
    request
    json = JSON.parse(response.body)

    expect(json['data']['passiveWantToItems'].pluck('name')).to(eq([want_to_item.name]))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request
    json = JSON.parse(response.body)

    expect(json['errors']).to(be)
  end
end
