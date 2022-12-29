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
    # return the collection given by the context
    # i.e: skills: ["Ruby", "Python", "Javascript"]
    # header_models => ["Ruby", "Python", "Javascript"]
    #
    # @return [Array] Array of values
    def header_models
      Array(context.public_send(header_models_context_key))
    end

    # The name of the dynamic_column
    #
    # i.e: With dynamic_column :skills
    # => :skills
    #
    # i.e: With dynamic_column :skills, as: :programming_languages
    # => :programming_languages
    #
    # @return [Symbol] Symbol
    def header_models_context_key
      options[:as] || column_name
    end
  end
end
