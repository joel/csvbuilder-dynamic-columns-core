# frozen_string_literal: true

class DynamicColumnModel
  include Csvbuilder::Model

  column :first_name
  column :last_name
  dynamic_column :skills
end
