module Persistent
  module Counters
    def self.included(klass)
      klass.extend ClassMethods
    end

    # Class methods that appear in your class when you include Redis::Objects.
    module ClassMethods

      # Define a new counter.  It will function like a regular instance
      # method, so it can be used alongside ActiveRecord, DataMapper, etc.
      def persistent_counter(name, options={})
        class_name = Struct.new(:name)
        redis_prefix class_name.new("redis_persistent_#{self.name.sub(/::/, '_')}")
        counter name, options
      end

    end
  end

  class Objects
    class << self
      attr_writer :redis, :redis_reset

      def redis
        @redis || Redis::Objects.redis.dup
      end

      def redis_reset
        @redis_reset || redis.dup
      end

      def init_pub_sub
        redis.config 'set', 'notify-keyspace-events', 'KEA'
        Thread.new do
          redis.psubscribe '__key*__:expire' do |on|

            on.pmessage do |pattern, channel, message|
              puts redis_reset.get(message)
              redis_reset.expire(message, 10)
              redis_reset.unsubscribe if message == "exit"
            end

          end
        end

      end
    end
  end
end
