require 'rails_helper'
require 'rspec/json_expectations'

RSpec.describe 'Api::V1::Accounts', type: :request do
  describe 'POST /api/v1/accounts' do
    context 'Valid params' do
      let(:account_params) { attributes_for(:account) }

      before { post '/api/v1/accounts/', params: account_params }

      it { expect(response).to have_http_status(:created) }

      it { expect(json).to include_json(account_params.except(:password)) }

      it 'create account' do
        expect do
          post '/api/v1/accounts/', params: account_params
        end.to change { Account.count }.by(1)
      end
    end

    context 'Invalid params' do
      context 'when not valid' do
        let(:account_params) { {foo: :bar} }

        before { post '/api/v1/accounts/', params: account_params }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      context 'when account id is already in use' do
        let(:account) { create(:account) }

        before { post '/api/v1/accounts/', params: account.as_json }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(json).to eql({ errors: 'account id is already in use, please provide a valid id' }.as_json) }
      end
    end
  end

  describe 'GET /api/v1/account/current' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/accounts/current'
    end

    context 'Authenticated' do
      let(:account) { create(:account) }

      before do
        get '/api/v1/accounts/current', headers: header_with_authentication(account)
      end

      it { expect(response).to have_http_status(:success) }

      it 'returns valid account in json' do
        expect(json).to eql(serialized(Api::V1::AccountSerializer, account))
      end
    end
  end
end
