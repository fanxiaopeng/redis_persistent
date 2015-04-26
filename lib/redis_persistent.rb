require 'thread'
require 'redis'
class RedisPersistent

  class << self
    def hello
      puts 'hello world'
    end
  end
end
