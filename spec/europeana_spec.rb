require 'spec_helper'

describe Europeana do
  before(:each) do
    Europeana.defaults!
  end
  
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
  
  describe ".max_retries" do
    it "defaults to 5" do
      expect(Europeana.max_retries).to eq(5)
    end
  end
  
  describe ".max_retries=" do
    it "sets the maximum number of retries" do
      Europeana.max_retries = 2
      expect(Europeana.max_retries).to eq(2)
    end
  end
  
  describe ".retry_delay" do
    it "defaults to 10" do
      expect(Europeana.retry_delay).to eq(10)
    end
  end
  
  describe ".retry_delay=" do
    it "sets the retry delay" do
      Europeana.retry_delay = 3
      expect(Europeana.retry_delay).to eq(3)
    end
  end
  
  describe ".defaults!" do
    it "sets retry delay to its default" do
      Europeana.retry_delay = 3
      expect { Europeana.defaults! }.to change { Europeana.retry_delay }.from(3).to(10)
    end
    
    it "sets max retries to its default" do
      Europeana.max_retries = 3
      expect { Europeana.defaults! }.to change { Europeana.max_retries }.from(3).to(5)
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
