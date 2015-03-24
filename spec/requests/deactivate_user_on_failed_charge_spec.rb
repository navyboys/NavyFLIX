require 'spec_helper'

describe 'deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_15jv9ECNtHoykpM8iD27Evya",
      "created" => 1427215500,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15jv9DCNtHoykpM8dN5rh78a",
          "object" => "charge",
          "created" => 1427215499,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "cad",
          "refunded" => false,
          "source" => {
            "id" => "card_15jv7dCNtHoykpM8Z8FjRu95",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 11,
            "exp_year" => 2017,
            "fingerprint" => "UL1mehXBFQgiqllu",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_5vV9KAIUhYRtsh"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_5vV9KAIUhYRtsh",
          "invoice" => nil,
          "description" => "payment to fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15jv9DCNtHoykpM8dN5rh78a/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5vmiuuazqrlaId",
      "api_version" => "2015-02-18"
    }
  end

  it 'deactivates a user with the webhook data from stripe for charge failed', :vcr do
    alice = Fabricate(:user, customer_token: 'cus_5vV9KAIUhYRtsh')
    post '/stripe_events', event_data
    expect(alice.reload).not_to be_active
  end
end