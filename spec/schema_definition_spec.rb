# frozen_string_literal: true

RSpec.describe "schema definition" do
  before do
    @t12n = T12n.start
  end

  it "must provide a block" do
    expect do
      @t12n.define_schema :x
    end.to raise_error(T12n::ArgumentError, "No block given")
  end

  it "block arity cannot be more than one" do
    expect do
      @t12n.define_schema(:x) { |a, b| }
    end.to raise_error(T12n::ArgumentError, "Unexpected proc arity: 2")
  end

  it "when arity is zero, the block scope is used for defining the schema" do
    block_self = nil
    @t12n.define_schema(:x) { block_self = self }

    expect(block_self).to be_a(T12n::SchemaBuilder)
  end

  it "when arity is one, the block scope is self and the argument is used for defining the schema" do
    block_self = nil
    block_arg = nil

    @t12n.define_schema :x do |arg|
      block_arg = arg
      block_self = self
    end

    expect(block_arg).to be_a(T12n::SchemaBuilder)
    expect(block_self).to eq(self)
  end
end
