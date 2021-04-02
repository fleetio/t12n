# frozen_string_literal: true

module T12n
  class SchemaStore
    def initialize
      @schema_by_name = {}
    end

    def save(schema)
      schema_by_name[schema.name] = schema
      :ok
    end

    def fetch(name)
      schema_by_name[name]
    end

    private

    attr_reader :schema_by_name
  end
end
