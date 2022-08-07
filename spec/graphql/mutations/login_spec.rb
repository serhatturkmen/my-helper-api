require 'rails_helper'

RSpec.describe('Query', type: :request) do
  let(:query_string) do
    %|
    mutation ($input: LoginInput!) {
      login(input: $input) {
        user {
          token
        }
        errors
      }
    }
    |
  end

  let(:username) { Faker::Internet.username(specifier: 6) }
  let(:password) { Faker::Internet.password(min_length: 6) }
  let(:user) { create(:user, username: username, password: password) }
  let(:variables) do
    {
      "input": {
        "username": username,
        "password": password
      }
    }
  end

  def request
    post('/graphql', params: { query: query_string, variables: variables })
  end

  before do
    user
  end

  it 'success' do
    request
    json = JSON.parse(response.body)

    expect(json['data']['login']['errors']).to(eq([]))
    expect(json['data']['login']['user']['token']).to(eq(user.token))
  end

  it 'fail login' do
    variables[:input][:username] = 'dot'

    request
    json = JSON.parse(response.body)

    expect(json['data']['login']['user']).to(be_nil)
    expect(json['data']['login']['errors']).to(be)
  end
end
