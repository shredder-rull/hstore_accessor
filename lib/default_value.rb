module HstoreAccessor  
  class DefaultValue

    attr_accessor :value

    def initialize(value=nil)
      @value = value
    end

    def has_value?
      @value.present?
    end

  end
end
