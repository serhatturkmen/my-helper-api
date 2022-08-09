require 'rails_helper'

RSpec.describe('Query', type: :request) do
  def query_string(id)
	 %|
    query {
      wantToItem(id: "#{id}") {
        name
        description
        url
        position
		  wantToCategory {
			  id
			  name
		  }
      }
    }
    |
  end

  let(:user) { create(:user) }
  let(:want_to_category) { create(:want_to_category, user: user) }
  let(:want_to_item) { create(:want_to_item, want_to_category: want_to_category) }
  let(:want_to_item_2) { create(:want_to_item, want_to_category: create(:want_to_category, user: create(:user))) }

  let(:headers) do
	 { 'Api-Token' => user.token }
  end

  before do
	 want_to_item
	 want_to_item_2
  end

  def request(id)
	 post('/graphql', params: { query: query_string(id) }, headers: headers)
  end

  it 'success' do
	 request(want_to_item.id)
	 json = JSON.parse(response.body)

	 expect(json['data']['wantToItem']['name']).to(eq(want_to_item.name))
  end

  it 'fail when another item id' do
	 request(want_to_item_2.id)
	 json = JSON.parse(response.body)

	 expect(json['errors']).to(be)
  end

  it 'invalid token' do
	 headers['Api-Token'] = 'invalid'

	 request(want_to_category.id)
	 json = JSON.parse(response.body)

	 expect(json['errors']).to(be)
  end
end
