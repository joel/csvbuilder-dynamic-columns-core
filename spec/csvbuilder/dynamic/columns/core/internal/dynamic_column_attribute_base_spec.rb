# frozen_string_literal: true

require "spec_helper"

module Csvbuilder
  RSpec.describe DynamicColumnAttributeBase do
    describe "instance" do
      let(:instance) { described_class.new(:skills, row_model) }
      let(:row_model_class) do
        Class.new do
          include Csvbuilder::Model
          dynamic_column :skills
        end
      end
      let(:row_model) { row_model_class.new }

      describe "#value" do
        subject(:value) { instance.value }

        let(:unformatted_value) { %w[Yes Yes No Yes Yes No] }

        before do
          row_model_class.class_eval do
            def self.format_dynamic_column_cells(*args)
              args
            end
          end
        end

        it "formats the column cells and memoizes" do
          expect(instance).to receive(:unformatted_value).and_return(unformatted_value)
          expect(value).to eql [unformatted_value, :skills, OpenStruct.new]
          expect(value.object_id).to eql instance.value.object_id
        end
      end

      describe "#process_cell_method_name" do
        subject(:process_cell_method_name) { instance.send(:process_cell_method_name) }

        it "calls the class method" do
          expect(described_class).to receive(:process_cell_method_name).with(:skills).and_call_original
          expect(process_cell_method_name).to be :skill
        end
      end

      describe "#call_process_cell" do
        subject(:call_process_cell) { instance.send(:call_process_cell, "formatted dynamic cell value", "dynamic header") }

        context "without alias" do
          before do
            row_model_class.class_eval do
              def skill(formatted_cell, source_header)
                "#{formatted_cell} - ** - #{source_header}"
              end
            end
          end

          it "calls the process_cell properly" do
            expect(call_process_cell).to eql "formatted dynamic cell value - ** - dynamic header"
          end
        end

        context "with alias" do
          let(:row_model_class) do
            Class.new do
              include Csvbuilder::Model
              dynamic_column :skills, as: :abilities
            end
          end

          before do
            row_model_class.class_eval do
              def ability(formatted_cell, source_header)
                "#{formatted_cell} - ** - #{source_header}"
              end
            end
          end

          it "calls the process_cell properly" do
            expect(call_process_cell).to eql "formatted dynamic cell value - ** - dynamic header"
          end
        end
      end
    end

    describe "class" do
      describe "::process_cell_method_name" do
        subject(:process_cell_method_name) { described_class.process_cell_method_name(:somethings) }

        it "returns a singularized name" do
          expect(process_cell_method_name).to be :something
        end
      end
    end
  end
end
