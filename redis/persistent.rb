class Redis
  module Persistent
    class << self
      # def included(klass)
      #   klass.send :include, Redis::Objects
      #   klass.send :include, Redis::Persistent::Counters
      # end
      def hello
        'hello world'
      end
    end
  end
end
