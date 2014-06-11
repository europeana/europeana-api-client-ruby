require 'spec_helper'

module Europeana
  describe "Errors" do
    describe "MissingAPIKeyError" do
      subject { Europeana::Errors::MissingAPIKeyError.new }
      
      it "has an informative message" do
        expect(subject.message).to match("Missing API key.")
      end
    end
  end
end
