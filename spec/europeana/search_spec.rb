require 'spec_helper'

module Europeana
  describe Search do
    before(:all) do
      @params = { :query => "test", :profile => "standard", :qf => "where:London", :rows => 100, :start => 1, :callback => "" }
      @api_key = "xyz"
    end
    
    before(:each) do
      Europeana.api_key = @api_key
    end
    
    describe "#new" do
      context "with no API request params" do
        subject { lambda { Europeana::Search.new } }
        it { should_not raise_error }
      end
      
      context "with API request params" do
        subject { Europeana::Search.new(@params) }
        it "should not raise error" do
          expect { subject }.not_to raise_error
        end
        it "stores the request params" do
          expect(subject.instance_variable_get(:@params)).to eq(@params)
        end
      end
    end
    
    describe "#params" do
      subject { Europeana::Search.new(@params) }
      it "gets params attribute" do
        expect(subject.params).to eq(@params)
      end
    end
    
    describe "#params=" do
      subject { Europeana::Search.new }
      
      context "valid params" do
        it "sets params attribute" do
          subject.params = @params
          expect(subject.instance_variable_get(:@params)).to eq(@params)
        end
      end
      
      it "validates param names" do
        expect { subject.params = { :invalid => "parameter" } }.to raise_error(/Unknown key: :?invalid/)
      end
    end
    
    describe "#request_uri" do
      it "returns a URI" do
        expect(subject.request_uri).to be_a(URI)
      end
      
      it "includes request params" do
        expect(subject.request_uri.to_s).to eq("http://www.europeana.eu/api/v2/search.json?query=&wskey=#{@api_key}")
      end
      
      it "handles Hash of qf params" do
        subject.params[:qf] = { :where => [ "London", "Paris" ], :what => "Photograph" }
        expect(subject.request_uri.to_s).to eq("http://www.europeana.eu/api/v2/search.json?query=&wskey=#{@api_key}&qf=where:London&qf=where:Paris&qf=what:Photograph")
      end
    end
    
    describe "#params_with_authentication" do
      subject { Europeana::Search.new }
      
      context "with API key" do
        it "adds API key to params" do
          subject.params = @params
          expect(subject.params_with_authentication).to eq(@params.merge(:wskey => @api_key))
        end
      end
      
      context "without API key" do
        it "raises an error" do
          subject.params = @params
          Europeana.api_key = nil
          expect { subject.params_with_authentication }.to raise_error(Europeana::Errors::MissingAPIKeyError)
        end
      end
    end
    
    describe "#execute" do
      subject { Europeana::Search.new(@params).execute }
      it_behaves_like "search request"
    end
  end
end
