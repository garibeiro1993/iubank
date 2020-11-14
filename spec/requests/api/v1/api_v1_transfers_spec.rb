# frozen_string_literal: true

require 'rails_helper'
require 'rspec/json_expectations'

RSpec.describe 'Api::V1::Transfer', type: :request do
  describe 'POST /api/v1/Transfer' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :post, '/api/v1/transfers/'
    end

    context 'Authenticated' do
      let(:source_account) { create(:account, id: 78694, balance: 200000) }
      let(:destination_account) { create(:account, id: 23454, balance: 200000) }

      let(:valid_params) do
        {
          destination_account_id: destination_account.id,
          amount: 10000
        }
      end

      context 'Valid params' do
        before do
          post '/api/v1/transfers/', params: valid_params, headers: header_with_authentication(source_account)
        end

        it { expect(response).to have_http_status(:created) }

        it { expect(json).to include_json(valid_params) }

        it 'create transfer' do
          expect do
            post '/api/v1/transfers/', params: valid_params, headers: header_with_authentication(source_account)
          end.to change { Transfer.count }.by(1)
        end
      end

      context 'Invalid params' do
        context 'when without account destination' do
          it 'returns error message destination account is must be present' do
            valid_params.delete(:destination_account_id)
            post '/api/v1/transfers/', params: valid_params, headers: header_with_authentication(source_account)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(json).to include_json({ 'errors': ['destination account is must be present'] }.as_json)
          end
        end

        context 'when without amount' do
          it 'returns error amount is invalid' do
            valid_params.delete(:amount)
            post '/api/v1/transfers/', params: valid_params, headers: header_with_authentication(source_account)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(json).to include_json({ 'errors': ['amount is invalid'] }.as_json)
          end
        end
      end
    end
  end
end
