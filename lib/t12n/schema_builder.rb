# frozen_string_literal: true

module T12n
  class SchemaBuilder
    def initialize(t12n)
      @t12n = t12n
      @schema_attrs = []
      @context_blocks = []
    end

    attr_reader :t12n, :schema_attrs, :context_blocks

    private

    def attrs(*names)
      names.each do |name|
        define_attr(name) { |object| object.public_send(name) }
      end
      :ok
    end

    def define_attr(name, &block)
      raise ArgumentError, "No block given" unless block

      schema_attrs << Attr.new(name.to_s, Serializer.from_proc(block))
      :ok
    end

    def with_context(&block)
      @context_blocks << block
      :ok
    end

    def associated_attrs(schema_name, attr_names = nil, &get_assoc_object)
      attr_name_set = attr_names.map(&:to_s).to_set if attr_names

      get_assoc_object ||= proc { |object| object.public_send(schema_name) }
      get_assoc_object = Serializer.from_proc(get_assoc_object)

      with_context do |context|
        schema = t12n.fetch_schema(schema_name, context)
        assoc_attrs = schema.attrs
        assoc_attrs = assoc_attrs.select { |attr| attr_name_set.include?(attr.name) } if attr_name_set

        assoc_attrs.each do |assoc_attr|
          define_attr("#{schema_name}.#{assoc_attr.name}") do |object|
            assoc_object = get_assoc_object.(object)
            assoc_attr.serializer.(assoc_object) if assoc_object
          end
        end
      end

      :ok
    end
  end
end
