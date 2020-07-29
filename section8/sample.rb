module Loggable
  def log(text)
    p "[LOG] #{text}"
  end
end

class Product
  # include で Loggable モジュールをinclude
  include Loggable

  def title
    log "mike!"
  end
end

class User
  include Loggable

  def name
    log "mikeneko!"
  end
end

product = Product.new
product.title
user = User.new
user.name

# freezeメソッドはfreezeされたレシーバ自身を返す
p [1,2,3].freeze

class Tempo
  include Comparable

  attr_reader :bpm

  def initialize(bpm)
    @bpm = bpm
  end

  def <=>(other)
    if other.is_a?(Tempo)
      bpm <=> other.bpm
    else
      nil
    end
  end

  def inspect
    "{bpm}bpm"
  end
end

t_120 = Tempo.new(120)
t_150 = Tempo.new(150)

p t_120 > t_150
p t_120 <= t_150
p t_120 == t_150

p Object.include?(Kernel)

s = 'abc'
s.extend(Loggable)
s.log('Hello')

module Baseball
  class Second
  end
end

module Clock
  class Second
  end
end

module Loggable2
  def self.log(text)
    p "[LOG] #{text}"
  end
end

Loggable2.log('Hello');

module AwesomeApi
  @base_url = ''
  @debug_mode = false
  class << self
    attr_accessor :base_url, :debug_mode
  end
end

AwesomeApi.base_url = 'https://mikeneko-blog.netlify.app'
AwesomeApi.debug_mode = true

p AwesomeApi.base_url
p AwesomeApi.debug_mode

require 'singleton'

class Configuration
  include Singleton

  attr_accessor :base_url, :debug_mode

  def initialize
    @base_url = ''
    @debug_mode
  end
end

config = Configuration.instance
config.base_url = 'https://mikeneko-blog.netlify.app'
config.debug_mode = true

other = Configuration.instance
p other.base_url
p other.debug_mode

module StringShuffle
  refine String do
    def shuffle
      chars.shuffle.join
    end
  end
end

# 通常shuffleは呼ぶことができない
# 'Alice'.shuffle

class User3
  using StringShuffle

  def initialize(name)
    @name = name
  end

  def shuffled_name
    @name.shuffle
  end
end

user = User3.new('Alice')
p user.shuffled_name

using StringShuffle
p 'Alice'.shuffle
