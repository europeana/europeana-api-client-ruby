require 'spec_helper'

module Europeana
  describe "::URL" do
    it "returns 'http://www.europeana.eu/api/v2'" do
      expect(Europeana::URL).to eq("http://www.europeana.eu/api/v2")
    end
  end
  
  describe ".api_key=" do
    before(:all) do
      @api_key = "xyz"
    end
    it "sets the API key" do
      Europeana.api_key = @api_key
      expect(Europeana.instance_variable_get(:@api_key)).to eq(@api_key)
    end
  end
  
  describe ".api_key" do
    before(:all) do
      @api_key = "xyz"
    end
    it "gets the API key" do
      Europeana.instance_variable_set(:@api_key, @api_key)
      expect(Europeana.api_key).to eq(@api_key)
    end
  end
  
  describe ".search" do
    subject { Europeana.search(@params) }
    it_behaves_like "search request"
  end
  
  describe ".search" do
    subject { Europeana.record(@record_id, @params) }
    it_behaves_like "record request"
  end
end
