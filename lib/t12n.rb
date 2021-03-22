# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module T12n
  class Error < StandardError; end
  # Your code goes here...
end
