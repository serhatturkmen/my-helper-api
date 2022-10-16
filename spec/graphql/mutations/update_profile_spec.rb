require 'rails_helper'

RSpec.describe('Query', type: :request) do
  let(:query_string) do
    %|
    mutation ($input: UpdateProfileInput!) {
      update_profile(input: $input) {
        user {
          id
          username
          email
        }
        errors
      }
    }
    |
  end

  let(:user) { create(:user) }
  let(:username) { Faker::Internet.username(specifier: 6) }
  let(:email) { Faker::Internet.email }
  let(:variables) do
    {
      input: {
        username: username,
        email: email
      }
    }
  end
  let(:headers) do
    { 'Api-Token' => user.token }
  end

  def request
    post('/graphql', params: { query: query_string, variables: variables.to_json }, headers: headers)
  end

  it 'success' do
    request
    json = JSON.parse(response.body)

    expect(json['data']['update_profile']['errors']).to(eq([]))
    expect(json['data']['update_profile']['user']['username']).to(eq(username))
    expect(json['data']['update_profile']['user']['email']).to(eq(email))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request
    json = JSON.parse(response.body)

    expect(json['data']['update_profile']['errors']).to(be)
  end

  it 'invalid username' do
    variables[:input][:username] = 'nil'

    request
    json = JSON.parse(response.body)

    expect(json['data']['update_profile']['errors']).to(eq(['Username is too short (minimum is 6 characters)']))
    expect(json['data']['update_profile']['user']).to(be_nil)
  end

  it 'invalid email' do
    variables[:input][:email] = 'test'

    request
    json = JSON.parse(response.body)

    expect(json['data']['update_profile']['errors']).to(eq(['Email is invalid']))
    expect(json['data']['update_profile']['user']).to(be_nil)
  end
end
