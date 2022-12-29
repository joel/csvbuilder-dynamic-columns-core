# Csvbuilder::Dynamic::Columns::Core

[Csvbuilder::Dynamic::Columns::Core](https://github.com/joel/csvbuilder-dynamic-columns-core) is part of the [csvbuilder-collection](https://github.com/joel/csvbuilder)

The Dynamic Columns Core contains the shared components used and extended by the Dynamic Columns Exporter and the Dynamic Columns Importer. It carries the architecture for the Dynamic Columns feature, and it can’t be used alone.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add csvbuilder-dynamic-columns-core

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install csvbuilder-dynamic-columns-core

## Usage

The Dynamic Columns Core adds a new entry into the
DSL of the Model:

```ruby
class UserCsvRowModel
  include Csvbuilder::Model

  column :first_name
  column :last_name

  dynamic_column :skills
end
```

Here we indicate we will have length variable headers about skills in the CSV file. Important notes, only one dynamic column can be defined per model, and it must be placed after the regular headers!

The Dynamic Columns add two new methods to the Model:

```ruby
class BasicRowModel
  include Csvbuilder::Model

  class << self

    # Safe to override. Method applied to each dynamic_column attribute
    #
    # @param cells [Array] Array of values
    # @param column_name [Symbol] Dynamic column name
    def format_dynamic_column_cells(cells, _column_name, _context)
      cells
    end

    # Safe to override
    #
    # @return [String] formatted header
    def format_dynamic_column_header(header_model, _column_name, _context)
      header_model
    end
  end
end
```

The collection of Objects is expected to be provided through the context with a key of the same name as the declared dynamic_column.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joel/csvbuilder-dynamic-columns. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/csvbuilder-dynamic-columns/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Csvbuilder::Dynamic::Columns project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/csvbuilder-dynamic-columns/blob/main/CODE_OF_CONDUCT.md).
