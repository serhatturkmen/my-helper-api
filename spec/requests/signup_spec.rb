require 'rails_helper'

RSpec.describe('Query', type: :request) do
  let(:query_string) do
    %|
    mutation ($input: SignupInput!) {
      signup(input: $input) {
        user {
          username
          email
          token
        }
        errors
      }
    }
    |
  end

  let(:email) { Faker::Internet.email }
  let(:username) { Faker::Internet.username(specifier: 6) }
  let(:password) { Faker::Internet.password(min_length: 6) }
  let(:variables) do
    {
      "input": {
        "email": email,
        "username": username,
        "password": password
      }
    }
  end

  def request
    post('/graphql', params: { query: query_string, variables: variables })
  end

  it 'success' do
    request
    json = JSON.parse(response.body)

    expect(json['data']['signup']['errors']).to(eq([]))
    expect(json['data']['signup']['user']['username']).to(eq(username))
    expect(json['data']['signup']['user']['email']).to(eq(email))
    expect(json['data']['signup']['user']['token']).to(eq(User.first.token))
  end

  it 'invalid email' do
    variables[:input][:email] = 'dot'
    request
    json = JSON.parse(response.body)

    expect(json['data']['signup']['user']).to(be_nil)
    expect(json['data']['signup']['errors']).to(be)
  end

  it 'invalid username' do
    variables[:input][:username] = 'dot'
    request
    json = JSON.parse(response.body)

    expect(json['data']['signup']['user']).to(be_nil)
    expect(json['data']['signup']['errors']).to(be)
  end
end
