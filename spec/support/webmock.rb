RSpec.configure do |config|
  config.before do
    Europeana::API.api_key = 'xyz'

    stub_request(:get, %r{www.europeana.eu/api/v2/record/[^/]+/[^/]+/self\.json}).
      to_return(body: lambda { |_| '{"success":true, "self":{"id":"' + record_id + '", "childrenCount":0, "hasChildren":false}}' })
  end
end
