# frozen_string_literal: true

RSpec.describe "attribute definition" do
  before do
    @t12n = T12n.start
  end

  it "defined attributes must provide a block" do
    expect do
      @t12n.define_schema :x do
        define_attr :a
      end
    end.to raise_error(T12n::ArgumentError, "No block given")
  end

  it "arity of defined attributes cannot be more than one" do
    expect do
      @t12n.define_schema :x do
        define_attr(:a) { |x, y| }
      end
    end.to raise_error(T12n::ArgumentError, "Unexpected proc arity: 2")
  end

  it "attribute serializers have an arity of one" do
    @t12n.define_schema :x do
      attrs(:attr1)
      define_attr(:attr2) { }
      define_attr(:attr3) { |obj| }
      define_attr(:attr4, &:y)
    end

    arities = @t12n.fetch_schema(:x).attrs.map { |a| a.serializer.arity }

    expect(arities).to eq([1, 1, 1, 1])
  end
end
