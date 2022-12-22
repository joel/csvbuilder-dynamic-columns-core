# frozen_string_literal: true

require "csvbuilder/core/internal/model/header"
require "csvbuilder/dynamic/columns/internal/concerns/dynamic_column_shared"

module Csvbuilder
  module Model
    class DynamicColumnHeader < Header
      include DynamicColumnShared

      def value
        header_models.map { |header_model| header_proc.call(header_model) }
      end

      def header_proc
        options[:header] || ->(header_model) { format_header(header_model) }
      end

      def format_header(header_model)
        row_model_class.format_dynamic_column_header(header_model, column_name, context)
      end
    end
  end
end
