# frozen_string_literal: true

class BasicRowModel
  include Csvbuilder::Model

  column :alpha
  column :beta, header: "String 2"
end
