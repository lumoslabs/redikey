module Redikey
  class KeyHelper
    DEFAULT_HASH_SIZE = 512
    attr_reader :resource_id, :prefixes, :separator

    def initialize(resource_id, separator: ':', prefixes: [])
      @resource_id = resource_id
      @prefixes = prefixes
      @separator = separator
    end

    def key(appended_prefix = nil)
      (prefixes + [appended_prefix, sharded_key]).compact.join(separator)
    end

    def field_key
      resource_id % DEFAULT_HASH_SIZE
    end

    private

    def sharded_key
      (resource_id / DEFAULT_HASH_SIZE).to_i
    end
  end
end
