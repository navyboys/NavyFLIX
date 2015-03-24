require 'spec_helper'

describe 'create payment on successful charge' do
  let(:event_data) do
    {
      "id" => "evt_15je9RCNtHoykpM8CrxblyXp",
      "created" => 1427150165,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_15je9RCNtHoykpM8LBLkQ8i5",
          "object" => "charge",
          "created" => 1427150165,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15je9QCNtHoykpM8J7TePEZV",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 3,
            "exp_year" => 2016,
            "fingerprint" => "cTYkI8ep8lhSZrdM",
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
          "captured" => true,
          "balance_transaction" => "txn_15je9RCNtHoykpM8PoIoJBr1",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_5vV9KAIUhYRtsh",
          "invoice" => "in_15je9RCNtHoykpM8MbTKMNKi",
          "description" => nil,
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
            "url" => "/v1/charges/ch_15je9RCNtHoykpM8LBLkQ8i5/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5vV9MMD5vA6YRV",
      "api_version" => "2015-02-18"
    }    
  end

  it 'creates a payment with the webhook from stripe for charge succeeded', :vcr do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it 'creates the payment associated with user', :vcr do
    alice = Fabricate(:user, customer_token: 'cus_5vV9KAIUhYRtsh')
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(alice)
  end

  it 'creates the payment with amount', :vcr do
    alice = Fabricate(:user, customer_token: 'cus_5vV9KAIUhYRtsh')
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it 'creates the payment with reference id', :vcr do
    alice = Fabricate(:user, customer_token: 'cus_5vV9KAIUhYRtsh')
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq('ch_15je9RCNtHoykpM8LBLkQ8i5')
  end
end