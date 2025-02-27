# frozen_string_literal: true

require "csvbuilder/core/internal/attribute_base"
require "csvbuilder/dynamic/columns/core/internal/concerns/dynamic_column_shared"

module Csvbuilder
  class DynamicColumnAttributeBase < AttributeBase
    include DynamicColumnShared

    # The value is the collection of cell's values
    # @return [Array] Array of values
    def value
      @value ||= row_model_class.format_dynamic_column_cells(unformatted_value, column_name, row_model.context)
    end

    # The source_cells is meant to be implemented in the concret class
    # @return [Array] Array of values
    def formatted_cells
      source_cells.map do |cell|
        row_model_class.format_cell(cell, column_name, row_model.context)
      end
    end

    def source_cells
      raise NotImplementedError
    end

    def unformatted_value
      raise NotImplementedError
    end

    protected

    # Instance access to singularized name of the dynamic_column
    #
    # @return [Symbol] value
    def process_cell_method_name
      self.class.process_cell_method_name(header_models_context_key)
    end

    # Calls the singularized method of the dynamic_column
    #
    # i.e: With dynamic_column :skills
    # => :skill
    #
    # Calls the process_cell to return the value of a Attribute given the args
    #
    # @return [Object] value
    def call_process_cell(*)
      row_model.public_send(process_cell_method_name, *)
    end

    class << self
      # The singularized name of the dynamic_column
      #
      # i.e: With dynamic_column :skills
      # => :skill
      #
      # i.e: With dynamic_column :skills, as: :programming_languages
      # => :programming_language
      #
      # @return [Symbol] Symbol
      def process_cell_method_name(column_name)
        column_name.to_s.singularize.to_sym
      end

      # define a method to process each cell of the attribute method
      # process_cell = one cell
      # attribute_method = many cells = [process_cell(), process_cell()...]
      def define_process_cell(row_model_class, column_name, &)
        row_model_class.define_proxy_method(process_cell_method_name(column_name), &)
      end
    end
  end
end
