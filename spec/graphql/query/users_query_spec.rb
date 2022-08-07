require 'rails_helper'

RSpec.describe('Query', type: :request) do
  let(:query_string) do
	 %|
    query {
      users {
        username
        email
      }
    }
    |
  end

  let(:user) { create(:user) }
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  let(:headers) do
	 { 'Api-Token' => user.token }
  end

  before do
	 user
	 user_1
	 user_2
  end

  def request
	 post('/graphql', params: { query: query_string }, headers: headers)
  end

  it 'success' do
	 request
	 json = JSON.parse(response.body)

	 expect(json['data']['users'].count).to(eq(3))
  end

  it 'invalid token' do
	 headers['Api-Token'] = 'invalid'

	 request
	 json = JSON.parse(response.body)

	 expect(json['errors']).to(be)
  end
end
