require 'rails_helper'

RSpec.describe('Query', type: :request) do
  let(:query_string) do
    %|
    mutation ($input: AddWantToCategoryInput!) {
      add_want_to_category(input: $input) {
        wantToCategory {
          name
          description
          active
          color
          position
        }
        errors
      }
    }
    |
  end

  let(:name) { Faker::Lorem.characters(number: 10) }
  let(:color) { Faker::Lorem.word }
  let(:user) { create(:user) }
  let(:variables) do
    {
      input: {
        name: name,
        color: color,
        position: 1
      }
    }
  end
  let(:headers) do
    { "Api-Token" => user.token }
  end

  before do
    user
  end

  def request
    post('/graphql', params: { query: query_string, variables: variables.to_json }, headers: headers)
  end

  it 'success' do
    request
    json = JSON.parse(response.body)

    expect(json['data']['add_want_to_category']['errors']).to(eq([]))
    expect(json['data']['add_want_to_category']['wantToCategory']['name']).to(eq(name))
    expect(json['data']['add_want_to_category']['wantToCategory']['active']).to(eq(true))
    expect(json['data']['add_want_to_category']['wantToCategory']['color']).to(eq(color))
    expect(json['data']['add_want_to_category']['wantToCategory']['position']).to(eq(1))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request
    json = JSON.parse(response.body)

    expect(json['data']['add_want_to_category']['errors']).to(be)
  end

  it 'invalid name' do
    variables[:input][:name] = nil

    request
    json = JSON.parse(response.body)

    expect(json['errors']).to(be)
  end
end
