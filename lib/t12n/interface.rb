# frozen_string_literal: true

module T12n
  Interface = Ivo.new(:schema_store) do
    def define_schema(name, &block)
      builder = SchemaBuilder.new(self)
      builder.instance_exec(&block)
      schema = Schema.new(name.to_s, builder.schema_attrs, builder.context_blocks)
      schema_store.save(schema)
      :ok
    end

    def fetch_schema(schema_name, context = nil)
      schema = schema_store.fetch(schema_name) or return

      if schema.context_blocks.any?
        builder = SchemaBuilder.new(self)
        schema.context_blocks.each { |block| builder.instance_exec(context, &block) }
        Schema.new(schema.name, (schema.attrs + builder.schema_attrs), [])
      else
        schema
      end
    end
  end
end
