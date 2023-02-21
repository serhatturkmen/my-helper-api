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

  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(min_length: 6) }
  let(:user) { create(:user, email: email, password: password) }
  let(:variables) do
    {
      "input": {
        "email": email,
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
    variables[:input][:email] = 'test@test.com'

    request
    json = JSON.parse(response.body)

    expect(json['data']['login']['user']).to(be_nil)
    expect(json['data']['login']['errors']).to(be)
  end
end
