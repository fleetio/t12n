# frozen_string_literal: true

module T12n
  Interface = Ivo.new(:schema_store) do
    def define_schema(name, &block)
      raise ArgumentError, "No block given" unless block

      raise ArgumentError, "Unexpected proc arity: #{block.arity}" if block.arity > 1

      builder = SchemaBuilder.new(self)

      if block.arity == 1
        block.call(builder)
      else
        builder.instance_exec(&block)
      end

      schema = Schema.new(name, builder.schema_attrs, builder.context_blocks)
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
