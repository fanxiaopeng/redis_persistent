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
        redis_prefix class_name.new("redis_persistent_#{self.model_name.collection}")
        default = { :expiration => 1000 }
        default.merge! options
        counter name, default
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
        redis1 = redis.dup
        redis2 = redis.dup
        redis1.config 'set', 'notify-keyspace-events', 'KEA'
        # Thread.new do
          redis1.psubscribe '__key*__:expire' do |on|

            on.pmessage do |pattern, channel, message|
              save_column(message, redis2.get(message))
              redis2.expire(message, 1000)
              redis2.unsubscribe if message == "exit"
            end

          end
        # end

      end

      def save_column(message, value)
        class_name, ob_id, column = split_key message
        class_name.gsub! /redis_persistent_/, ''
        model_name = class_name.classify.constantize
        ob = model_name.find_by id: ob_id
        column += "_persistent"
        ob.update(column => value)
      rescue => err
        p err
      end

      def split_key str
        str.split ':'
      end
    end
  end
end
