require 'rails_helper'

RSpec.describe('Query', type: :request) do
  let(:query_string) do
    %|
    mutation ($input: AddWantToItemInput!) {
      add_want_to_item(input: $input) {
        wantToItem {
          id
          name
          description
          url
          active
          position
          wantToCategory {
            name
            description
          }
        }
        errors
      }
    }
    |
  end

  let(:want_to_category) { create(:want_to_category, user: user) }
  let(:name) { Faker::Lorem.characters(number: 10) }
  let(:description) { Faker::Lorem.characters(number: 10) }
  let(:url) { Faker::Internet.url }
  let(:user) { create(:user) }

  let(:variables) do
    {
      input: {
        name: name,
        description: description,
        url: url,
        active: true,
        position: 1,
        want_to_category_id: want_to_category.id,
      }
    }
  end

  let(:headers) do
    { 'Api-Token' => user.token }
  end

  before do
    user
    want_to_category
  end

  def request
    post('/graphql', params: { query: query_string, variables: variables.to_json }, headers: headers)
  end

  it 'success' do
    request
    json = JSON.parse(response.body)

    expect(json['data']['add_want_to_item']['errors']).to(eq([]))
    expect(json['data']['add_want_to_item']['wantToItem']['name']).to(eq(name))
    expect(json['data']['add_want_to_item']['wantToItem']['active']).to(eq(true))
    expect(json['data']['add_want_to_item']['wantToItem']['position']).to(eq(1))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request
    json = JSON.parse(response.body)

    expect(json['data']['add_want_to_item']['errors']).to(be)
  end

  it 'invalid name' do
    variables[:input][:name] = nil

    request
    json = JSON.parse(response.body)

    expect(json['errors']).to(be)
  end
end
