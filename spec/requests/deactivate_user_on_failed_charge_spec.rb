require 'spec_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_102lnq2Q662YjSqn69S5uw6L",
      "created" => 1382014239,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_102lnq2Q662YjSqnGpijcdzi",
          "object" => "charge",
          "created" => 1382014239,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "cad",
          "refunded" => false,
          "card" => {
            "id" => "card_102lnp2Q662YjSqn8KgfZ7N2",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 10,
            "exp_year" => 2016,
            "fingerprint" => "mn4GabznhMpiPHiA",
            "customer" => "cus_2lFyhfAd8SEagz",
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
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_2lFyhfAd8SEagz",
          "invoice" => nil,
          "description" => "payment to fail",
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_2lnqLyyPu3jzlI"
    }
  end

  it "deactivates a user with the web hook data from stripe for charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_2lFyhfAd8SEagz")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end