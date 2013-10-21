require 'spec_helper'

describe "create payment on successful charge" do
  let(:event_data) do
      {
        "id" => "evt_102lAE2Q662YjSqnlk5bkL8w",
        "created" => 1381866877,
        "livemode" => false,
        "type" => "charge.succeeded",
        "data" => {
          "object" => {
            "id" => "ch_102lAE2Q662YjSqn87URD0Ly",
            "object" => "charge",
            "created" => 1381866877,
            "livemode" => false,
            "paid" => true,
            "amount" => 999,
            "currency" => "cad",
            "refunded" => false,
            "card" => {
              "id" => "card_102lAE2Q662YjSqnJNrPNnCd",
              "object" => "card",
              "last4" => "4242",
              "type" => "Visa",
              "exp_month" => 12,
              "exp_year" => 2013,
              "fingerprint" => "RIfLSrcbOjUrHlZH",
              "customer" => "cus_2lAEdcjL6SFI3V",
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
              "address_zip_check" => nil
            },
            "captured" => true,
            "refunds" => [],
            "balance_transaction" => "txn_102lAE2Q662YjSqnYM5GWooR",
            "failure_message" => nil,
            "failure_code" => nil,
            "amount_refunded" => 0,
            "customer" => "cus_2lAEdcjL6SFI3V",
            "invoice" => "in_102lAE2Q662YjSqnL4bbvvMl",
            "description" => nil,
            "dispute" => nil,
            "metadata" => {}
          }
        },
        "object" => "event",
        "pending_webhooks" => 1,
        "request" => "iar_2lAEttogsK1wMX"
      }
    end
  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "create the payment associated with user", :vcr  do
    alice = Fabricate(:user, customer_token: "cus_2lAEdcjL6SFI3V")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "create the payment with the amount", :vcr  do
    alice = Fabricate(:user, customer_token: "cus_2lAEdcjL6SFI3V")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "create the payment with reference id", :vcr  do
    alice = Fabricate(:user, customer_token: "cus_2lAEdcjL6SFI3V")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_102lAE2Q662YjSqn87URD0Ly")
  end
end