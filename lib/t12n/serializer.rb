# frozen_string_literal: true

module T12n
  class Serializer
    class << self
      def from_proc(prc)
        case prc.arity
        when 0
          ->(_object) { prc.() }
        when 1, -1, -2
          ->(object) { prc.(object) }
        else
          raise T12n::ArgumentError, "Unexpected proc arity: #{prc.arity}"
        end
      end
    end
  end
end
