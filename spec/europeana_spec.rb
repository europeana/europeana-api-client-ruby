require 'spec_helper'

module Europeana
  describe "URL" do
    it "returns 'http://www.europeana.eu/api/v2'" do
      expect(Europeana::URL).to eql("http://www.europeana.eu/api/v2")
    end
  end
end
