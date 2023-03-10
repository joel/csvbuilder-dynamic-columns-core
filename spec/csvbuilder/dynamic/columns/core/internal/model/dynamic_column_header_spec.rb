# frozen_string_literal: true

require "spec_helper"

module Csvbuilder
  module Model
    RSpec.describe DynamicColumnHeader do
      let(:instance) { described_class.new(:skills, row_model_class, skills: "context") }
      let(:row_model_class) do
        Class.new(DynamicColumnModel) do
          def self.format_dynamic_column_header(*args)
            args.join("__")
          end
        end
      end

      describe "#value" do
        subject(:value) { instance.value }

        it "returns the formatted header" do
          expect(value).to eql ["context__skills__#<OpenStruct skills=\"context\">"]
        end

        context "with :header option" do
          let(:row_model_class) do
            Class.new do
              include Csvbuilder::Model
              column :first_name
              column :last_name
              dynamic_column :skills, header: ->(header_model) { "#{header_model}_changed" }
            end
          end

          it "returns the option calculated value" do
            expect(value).to eql ["context_changed"]
          end
        end
      end
    end
  end
end
