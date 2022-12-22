# frozen_string_literal: true

require "spec_helper"

module Csvbuilder
  header_models = Skill.all

  RSpec.describe DynamicColumnsBase do
    let(:instance) { row_model_class.new("Mario", "Italian") }
    let(:row_model_class) do
      Class.new do
        include BasicDynamicColumns
        dynamic_column :skills
      end
    end

    shared_context "standard columns defined" do
      let(:row_model_class) do
        Class.new do
          include BasicDynamicColumns
          column :first_name
          column :last_name
          dynamic_column :skills
        end
      end
    end

    before do
      allow(instance).to receive(:context).and_return(OpenStruct.new)
      allow(instance).to receive(:header_models).and_return(header_models)
    end

    describe "instance" do
      describe "#attribute_objects" do
        it_behaves_like "attribute_objects_method",
                        %i[skills],
                        BasicDynamicColumnAttribute => 1

        with_context "standard columns defined" do
          it_behaves_like "attribute_objects_method",
                          %i[first_name last_name skills],
                          BasicAttribute => 2,
                          BasicDynamicColumnAttribute => 1
        end
      end

      describe "#attributes" do
        subject(:attributes) { instance.attributes }

        it "returns the map of column_name => public_send(column_name)" do
          expect(attributes).to eql(skills: header_models)
        end

        with_context "standard columns defined" do
          it "returns the map of column_name => public_send(column_name)" do
            expect(attributes).to eql(first_name: "Mario", last_name: "Italian", skills: header_models)
          end
        end
      end

      describe "#original_attributes" do
        subject(:original_attributes) { instance.original_attributes }

        it "has dynamic columns" do
          expect(original_attributes).to eql(skills: header_models)
        end

        with_context "standard columns defined" do
          it "has standard and dynamic columns" do
            expect(original_attributes).to eql(first_name: "Mario", last_name: "Italian", skills: header_models)
          end
        end
      end

      describe "#original_attribute" do
        let(:column_name)    { :skills }
        let(:expected_value) { header_models }

        subject(:original_attribute) { instance.original_attribute(column_name) }

        it do
          expect(original_attribute).to eql expected_value
        end

        context "with invalid column_name" do
          let(:column_name) { :not_a_column }

          it do
            expect(original_attribute).to be_nil
          end
        end
      end

      describe "#formatted_attributes" do
        subject(:formatted_attributes) { instance.formatted_attributes }

        before do
          row_model_class.class_eval do
            def self.format_cell(*args)
              args.join("__")
            end
          end
        end

        it "returns all attributes of dynamic columns" do
          expect(formatted_attributes).to eql(
            skills: [
              "Ruby__skills__#<OpenStruct>",
              "Python__skills__#<OpenStruct>",
              "Java__skills__#<OpenStruct>",
              "Rust__skills__#<OpenStruct>",
              "Javascript__skills__#<OpenStruct>",
              "GoLand__skills__#<OpenStruct>"
            ]
          )
        end

        with_context "standard columns defined" do
          it "returns all attributes including the dynamic columns" do
            expect(formatted_attributes).to eql(
              first_name: "Mario_source__first_name__#<OpenStruct>",
              last_name: "Italian_source__last_name__#<OpenStruct>",
              skills: [
                "Ruby__skills__#<OpenStruct>",
                "Python__skills__#<OpenStruct>",
                "Java__skills__#<OpenStruct>",
                "Rust__skills__#<OpenStruct>",
                "Javascript__skills__#<OpenStruct>",
                "GoLand__skills__#<OpenStruct>"
              ]
            )
          end
        end
      end
    end

    describe "class" do
      it_behaves_like "defines_attributes_methods_safely", { alpha: "Mario", beta: "Italian" }, BasicDynamicColumns
    end
  end
end
