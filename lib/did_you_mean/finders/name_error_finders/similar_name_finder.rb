module DidYouMean
  class SimilarNameFinder
    include BaseFinder
    attr_reader :name, :_methods, :_local_variables, :_instance_variables

    def initialize(exception)
      @name                = exception.name
      @_methods            = exception.frame_binding.eval("methods")
      @_local_variables    = exception.frame_binding.eval("local_variables")
      @_instance_variables = exception.frame_binding.eval("instance_variables").map do |name|
        name.to_s.tr(AT, EMPTY)
      end
    end

    def words
      local_variable_names + method_names + instance_variable_names
    end

    alias target_word name

    def local_variable_names
      _local_variables.map {|word| StringDelegator.new(word.to_s, :local_variable) }
    end

    def method_names
      _methods.map {|word| StringDelegator.new(word.to_s, :method, prefix: POUND) }
    end

    def instance_variable_names
      _instance_variables.map {|word| StringDelegator.new(word.to_s, :instance_variable) }
    end
  end
end
