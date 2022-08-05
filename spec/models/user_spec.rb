require 'rails_helper'

RSpec.describe User, type: :model do
  it { validate_uniqueness_of(:username) }
  it { validate_uniqueness_of(:email) }

  it { validate_presence_of(:username) }
  it { validate_presence_of(:email) }

  it { validate_length_of(:username).is_at_least(6) }

  it { is_expected.to allow_value('email@address.com').for(:email) }
  it { is_expected.to allow_value('email+support@address.com').for(:email) }
  it { is_expected.to allow_value('email+1@address.com').for(:email) }
  it { is_expected.to_not allow_value('foo').for(:email) }
  it { is_expected.to_not allow_value('foo.com').for(:email) }

  it 'generate_token' do
    user = build(:user)
    expect(user.token).to(be_nil)
    expect { user.save! }.to(change { user.token })
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  token                  :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
