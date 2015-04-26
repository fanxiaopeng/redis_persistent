Gem::Specification.new do |s|
  s.name        = 'redis_persistent'
  s.version     = '0.0.0'
  s.date        = '2015-04-26'
  s.summary     = 'redis persistence event'
  s.description = 'value in ActiveRecord persistence to Relational Database'
  s.authors     = ["Fan Xiaopeng"]
  s.email       = 'fanxiaopeng515@163.com'
  # s.files       = `git ls-files`.split($/).reject{|e|e[0]=='.'}
  s.files       = ['lib/redis_persistent.rb', 'redis/persistent.rb']
  s.homepage    = 'https://github.com/fanxiaopeng/redis_persistent'

  s.add_dependency "redis", ">= 3.0.2"
  s.add_dependency "redis-object", ">= 1.0.0"
end