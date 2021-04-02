# frozen_string_literal: true

class CustomSchemaStore
  def save(schema)
    @schema = schema
  end

  def fetch(name)
    @schema if @schema.name == name
  end
end

RSpec.describe "interface" do
  it "has a version number" do
    expect(T12n::VERSION).not_to be nil
  end

  it "can provide a custom schema store" do
    schema_store = CustomSchemaStore.new

    t12n = T12n.start(schema_store: schema_store)

    t12n.define_schema(:x) {}

    expect(t12n.fetch_schema(:x)).to_not eq(nil)

    expect(t12n.fetch_schema(:y)).to eq(nil)
  end
end
