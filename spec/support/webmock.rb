# frozen_string_literal: true
RSpec.configure do |config|
  config.before do
    Europeana::API.api_key = 'xyz'

    stub_request(:get, %r{www.europeana.eu/api/record/[^/]+/[^/]+/self\.json}).
      to_return(body: ->(_) { '{"success":true, "self":{"id":"' + record_id + '", "childrenCount":0, "hasChildren":false}}' })

    stub_request(:get, %r{www.europeana.eu/api/record/[^/]+/[^/]+/parent\.json}).
      to_return(body: ->(_) { '{"success":true, "self":{"id":"' + record_id + '", "childrenCount":5, "hasChildren":false}, "parent":{}}' })

    stub_request(:get, %r{www.europeana.eu/api/record/[^/]+/[^/]+/children\.json}).
      to_return(body: ->(_) { '{"success":true, "self":{"id":"' + record_id + '", "childrenCount":5, "hasChildren":false}, "children":[]}' })
  end
end
