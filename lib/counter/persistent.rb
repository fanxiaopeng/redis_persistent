require 'redis-objects'
require 'counter/counters'


module Persistent
  class << self
    def included(klass)
      klass.send :include, Redis::Objects
      klass.send :include, Persistent::Counters
    end
  end
end
