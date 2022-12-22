# frozen_string_literal: true

require "csvbuilder/core/public/model"

require "csvbuilder/dynamic/columns/concerns/model/dynamic_columns"
Csvbuilder::Model.include(Csvbuilder::Model::DynamicColumns)
