require "fast_memoize/version"

module FastMemoize
  class UndefinedMethodError < StandardError; end
  class ParameterizedMethodError < StandardError; end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def memoize(method)
      raise ParameterizedMethodError.new("Can't memoize a parameterized method") if instance_method(method).arity > 0

      alias_method :"memoized_#{method}", method
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{method}
          return @#{method} if defined?(@#{method})

          @#{method} = memoized_#{method}
        end
      METHOD
    rescue NameError
      raise UndefinedMethodError.new("Can't memoize undefined method: #{method}")
    end
  end
end
