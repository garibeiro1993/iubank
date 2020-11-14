require 'rails_helper'

describe Operations::Transfers::Create, type: :operations do
  let(:source_account) { create(:account, id: 7869, balance: 200000) }
  let(:destination_account) { create(:account, id: 2345, balance: 200000) }
  let(:valid_params) do
    {
      source_account_id: source_account.id,
      destination_account_id: destination_account.id,
      amount: 10000
    }
  end

  subject { described_class.call(valid_params) }

  describe '#call' do
    context 'Valid params' do
      it 'return success' do
        expect(subject.success?).to be_truthy
      end

      it 'create a new transfer' do
        expect { subject }.to change { Transfer.count }.by(1)
      end

      it 'new transfer must have correct values' do
        new_transfer = subject.data

        expect(new_transfer.source_account_id).to eq(7869)
        expect(new_transfer.destination_account_id).to eq(2345)
        expect(new_transfer.amount).to eq(10000)
      end

      it 'the amount is debited from the source account' do
        new_balance = subject.data.source_account.balance

        expect(new_balance).to eq(190000)
      end

      it 'the amount is deposited in the destination account' do
        new_balance = subject.data.destination_account.balance

        expect(new_balance).to eq(210000)
      end
    end

    context 'Invalid params' do
      context 'validate fields' do
        context 'when source account not filled' do
          it 'returns error source account is must be present' do
            valid_params.delete(:source_account_id)

            expect(subject.success?).to be_falsey
            expect(subject.errors).to eq(['source account is must be present'])
          end
        end

        context 'when destination account not filled' do
          it 'returns error destination account is must be present' do
            valid_params.delete(:destination_account_id)

            expect(subject.success?).to be_falsey
            expect(subject.errors).to eq(['destination account is must be present'])
          end
        end

        context 'when amount is invalid' do
          context 'when not been filled' do
            it 'returns error amount is invalid' do
              valid_params[:amount] = nil

              expect(subject.success?).to be_falsey
              expect(subject.errors).to eq(['amount is invalid'])
            end
          end

          context 'when value is zero' do
            it 'returns error amount is invalid' do
              valid_params[:amount] = 0

              expect(subject.success?).to be_falsey
              expect(subject.errors).to eq(['amount is invalid'])
            end
          end

          context 'when value is negative' do
            it 'returns error amount is invalid' do
              valid_params[:amount] = -10

              expect(subject.success?).to be_falsey
              expect(subject.errors).to eq(['amount is invalid'])
            end
          end
        end

        context 'when source account is same destination' do
          it 'returns error destination account cannot be the same' do
            valid_params[:destination_account_id] = source_account.id

            expect(subject.success?).to be_falsey
            expect(subject.errors).to eq(['source and destination account cannot be the same'])
          end
        end
      end

      context 'when validate accounts' do
        context 'when source account not exists' do
          it 'returns error source account not found' do
            valid_params[:source_account_id] = -1

            expect(subject.success?).to be_falsey
            expect(subject.errors).to eq(['Source account not found'])
          end
        end

        context 'when destination account not exists' do
          it 'returns error destination account not found' do
            valid_params[:destination_account_id] = -1

            expect(subject.success?).to be_falsey
            expect(subject.errors).to eq(['Destination account not found'])
          end
        end
      end

      context 'when source account no balance for this operation' do
        it 'returns error source account not have balance for this operation' do
          valid_params[:amount] = 200001

          expect(subject.success?).to be_falsey
          expect(subject.errors).to eq(['source account not have balance for this operation'])
        end
      end
    end
  end
end
