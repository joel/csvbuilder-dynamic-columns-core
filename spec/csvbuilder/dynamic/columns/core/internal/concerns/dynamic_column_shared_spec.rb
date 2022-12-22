# frozen_string_literal: true

require "spec_helper"

module Csvbuilder
  RSpec.describe DynamicColumnShared do
    let(:klass) do
      Class.new(OpenStruct) { include Csvbuilder::DynamicColumnShared }
    end
    let(:instance) { klass.new }
    let(:options) { {} }

    before do
      allow(instance).to receive(:column_name).and_return(:skills)
      allow(instance).to receive(:options).and_return(options)
    end

    describe "#header_models" do
      subject(:header_models) { instance.header_models }

      let(:context) { { skills: "waka" } }

      before { expect(instance).to receive(:context).and_return(OpenStruct.new(context)) }

      it "calls the method of the column_name on the context as an array" do
        expect(header_models).to eql ["waka"]
      end

      context "when the context doesn't have #header_models_context_key" do
        let(:context) { {} }

        it "returns an empty array" do
          expect(header_models).to eql []
        end
      end
    end

    describe "#header_models_context_key" do
      subject(:header_models_context_key) { instance.header_models_context_key }

      it "defaults to the column_name" do
        expect(header_models_context_key).to be :skills
      end

      context "with option given" do
        let(:options) { { header_models_context_key: :something } }

        it "returns the option value" do
          expect(header_models_context_key).to be :something
        end
      end
    end
  end
end
