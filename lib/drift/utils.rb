module Drift
  module Utils
    def self.symbolize_keys(object)
      case object
      when Hash
        object.inject({}) { |memo,(k,v)|
          memo[(k.to_sym rescue k)] = Hash === v ? symbolize_keys(v) : v
          memo
        }
      when Array
        object.map { |v| symbolize_keys(v) }
      else
        object
      end
    end
  end
end

# Drift::Utils.symbolize_keys([1, {'goo' => { 'bar' => 1, :gyp => ['x'] }, foo: Object.new }])
