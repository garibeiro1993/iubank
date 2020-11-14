# frozen_string_literal: true

module Operations
  module Transfers
    class Create < ApplicationOperation
      attr_accessor :source_account_id, :destination_account_id, :amount

      def initialize(params)
        super
        @source_account_id = params[:source_account_id]
        @destination_account_id = params[:destination_account_id]
        @amount = params[:amount].to_i
      end

      def call
        valid_transfer?
        create_transfer! if @errors.blank?
        result
      end

      private

      def valid_transfer?
        validate_fields
        validate_accounts if @errors.blank?
        validate_balance if @errors.blank?
      end

      def create_transfer!
        @resource = Transfer.new.tap do |transfer|
          transfer.source_account_id = source_account_id
          transfer.destination_account_id = destination_account_id
          transfer.amount = amount
          transfer.save!
        end
      end

      def validate_fields
        add_error('source account is must be present') if source_account_id.blank?
        add_error('destination account is must be present') if destination_account_id.blank?
        add_error('amount is invalid') if amount_invalid?
        add_error('source and destination account cannot be the same') if same_accounts?
      end

      def validate_accounts
        add_error('Source account not found') unless Account.exists? @source_account_id
        add_error('Destination account not found') unless Account.exists? @destination_account_id
      end

      def validate_balance
        add_error('source account not have balance for this operation') if source_less_balance?
      end

      def same_accounts?
        source_account_id.eql? destination_account_id
      end

      def source_less_balance?
        Account.get_balance(source_account_id) < amount
      end

      def amount_invalid?
        @amount.blank? || @amount.zero? || @amount.negative?
      end

      def add_error(message)
        @errors << message
      end
    end
  end
end
