# frozen_string_literal: true

require "csvbuilder/core/internal/concerns/column_shared"

module Csvbuilder
  module DynamicColumnShared
    include ColumnShared
    extend ActiveSupport::Concern

    #
    # row_model_class
    #
    def column_index
      @column_index ||= row_model_class.dynamic_column_index(column_name)
    end

    def options
      row_model_class.dynamic_columns[column_name]
    end

    #
    # header models
    #
    def header_models
      Array(context.public_send(header_models_context_key))
    end

    def header_models_context_key
      options[:header_models_context_key] || column_name
    end
  end
end
