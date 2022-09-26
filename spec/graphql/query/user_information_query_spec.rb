require 'rails_helper'

RSpec.describe('Query', type: :request) do
  let(:query_string) do
    %|
    query {
      userInformation {
        username
        email
      }
    }
    |
  end

  let(:user) { create(:user) }

  let(:headers) do
    { 'Api-Token' => user.token }
  end

  before do
    user
  end

  def request
    post('/graphql', params: { query: query_string }, headers: headers)
  end

  it 'success' do
    request
    json = JSON.parse(response.body)

    expect(json['data']['userInformation']['username']).to(eq(user.username))
  end

  it 'invalid token' do
    headers['Api-Token'] = 'invalid'

    request
    json = JSON.parse(response.body)

    expect(json['errors']).to(be)
  end
end
