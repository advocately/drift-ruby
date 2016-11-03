require 'spec_helper'
require 'multi_json'

describe Drift::Client do
  let(:client)   { Drift::Client.new('x') }
  let(:response) { double("Response", code: 200) }
  let(:headers) {
    {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/json',
      'User-Agent'=>'Ruby'
    }
  }

  def api_uri(path)
    "https://event.api.drift.com/#{path}"
  end

  describe "#identify" do
    it "sends a POST request to drift's customer API" do
      stub_request(:post, api_uri('identify'))
        .with(body: '{"attributes":{"name":"Tom"},"userId":1,"orgId":"x"}',
              headers: headers)
        .to_return(status: 200, body: "", headers: {})

      client.identify(1, { name: 'Tom' })
    end

    it "sends along all attributes" do
      time = 1478203244
      body = '{"attributes":{"email":"customer@example.com","created_at":1478203244,"first_name":"Bob","plan":"basic"},"userId":1,"orgId":"x"}'
      stub_request(:post, api_uri('identify')).with(
        body: body, headers: headers
      ).to_return(status: 200, body: "", headers: {})

      client.identify(1, {
        email: "customer@example.com",
        created_at: time,
        first_name: "Bob",
        plan: "basic"
      })
    end
  end

  describe "#track" do
    it "sends a track event" do
      body = '{"userId":5,"orgId":"x","event":"purchase","attributes":{},"createdAt":null}'
      stub_request(:post, api_uri('track'))
        .with(body: body, headers: headers)
        .to_return(status: 200, body: "", headers: {})

      client.track(5, "purchase", {})
    end

    it "sends any optional event attributes" do
      body = '{"userId":5,"orgId":"x","event":"purchase","attributes":{"type":"socks","price":"13.99"},"createdAt":null}'
      stub_request(:post, api_uri('track'))
        .with(body: body, headers: headers)
        .to_return(status: 200, body: "", headers: {})

      client.track(5, "purchase", type: "socks", price: "13.99")
    end

    it "allows sending of a created_at date" do
      stub_request(:post, api_uri('track'))
        .with(body: {
          orgId: 'x',
          userId: 5,
          event: "purchase",
          attributes: {
            type: "socks",
            price: "13.99",
          },
          createdAt: 1561231234
        }, headers: headers)
        .to_return(status: 200, body: "", headers: {})

      client.track(5, "purchase", type: "socks", price: "13.99", created_at: 1561231234)
    end
  end
end
