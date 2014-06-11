require 'spec_helper'

module Europeana
  describe Search do
    before(:all) do
      @params = { :query => "test", :profile => "standard", :qf => "where:London", :rows => 100, :start => 1, :callback => "" }
      @api_key = "xyz"
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
        expect { subject.params = { :invalid => "parameter" } }.to raise_error("Unknown key: invalid")
      end
    end
    
    describe "#params_with_authentication" do
      subject { Europeana::Search.new }
      
      context "with API key" do
        it "adds API key to params" do
          subject.params = @params
          Europeana.api_key = @api_key
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
