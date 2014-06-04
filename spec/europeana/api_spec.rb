require 'spec_helper'

module Europeana
  describe "API" do
    describe "URL" do
      it "returns 'http://www.europeana.eu/api/v2'" do
        expect(Europeana::API::URL).to eql("http://www.europeana.eu/api/v2")
      end
    end
  end
end
