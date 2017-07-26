# frozen_string_literal: true
RSpec.describe Europeana::API::Entity do
  it_behaves_like 'a resource with API endpoint', :resolve
  it_behaves_like 'a resource with API endpoint', :fetch
  it_behaves_like 'a resource with API endpoint', :suggest
end
