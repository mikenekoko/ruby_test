class User
end

class OrderItem
end

p User.new

class User
  def initialize
    p 'Initialized.'
  end
end

User.new

class User
  def initialize(name)
    @name = name
  end

  def hello
    p "Hello, I am #{@name}"
  end
end

user = User.new("mike")
user.hello

class User
  def initialize(name)
    @name = name
  end

  def hello
    shuffled_name = @name.chars.shuffle.join
    p "Hello, I am #{shuffled_name}"
  end
end

user = User.new("mike")
user.hello

class User
  def initialize(name)
    @name = name
  end

  def hello
    shuffled_name = @name.chars.shuffle.join
    p "Hello, I am #{shuffled_name}"
  end

  # @nameを外部から参照する
  def name
    p @name
  end

  # @nameを外部から更新する
  def name=(value)
    @name = value
  end
end

user = User.new("mike")
user.name
user.name="koko"
user.name

class User
  def initialize(name)
    @name = name
  end

  #これはクラスメソッド
  def self.create_users(names)
    names.map do |name|
      User.new(name)
    end
  end

  def hello
    p "Hello, I am #{@name}"
  end
end

names = ['mike', 'neko']
users = User.create_users(names)
users.each do |user|
  user.hello
end

class Product
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def self.format_price(price)
    "#{price}円"
  end

  def to_s
    formatted_price = Product.format_price(price)
    "name: #{name}, price: #{formatted_price}"
  end
end

product = Product.new("mikeneko", 145)
p product.to_s

class Hoge
end
hoge = Hoge.new
p hoge.methods.sort

p hoge.class
# それはHogeクラスのインスタンスか？
p hoge.instance_of?(Hoge)
# それはObjectクラスまたはObjectクラスを継承しているか？
p hoge.is_a?(Object)

# 当然Hogeを比較したらそのままtrueが返ってくる
p hoge.is_a?(Hoge)

class Product2
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end
product = Product2.new('mikeneko', 1000)
p product.name
p product.price

class DVD < Product2
  attr_reader :running_time

  def initialize(name, price, running_time)
    super(name, price)
    @running_time = running_time
  end
end
dvd = DVD.new('mike!', 10000, 120)
p dvd.name
p dvd.price
p dvd.running_time

class Product3
end

product = Product3.new()
p product.to_s

class Product3
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def to_s
    "name: #{name}, price: #{price}"
  end
end

class DVD3 < Product3
  attr_reader :running_time

  def initialize(name, price, running_time)
    super(name, price)
    @running_time = running_time
  end

  def to_s
    "#{super}, running_time: #{running_time}"
  end
end
dvd = DVD3.new('mike!', 10000, 120)
p dvd.to_s

class Foo
  def self.hello
    "Hello!"
  end
end

class Bar < Foo
end

p Bar.hello

class User5
  class << self
    private

    def hello
      p 'hello!!'
    end
  end
end

# User5.hello

class User6
  def self.hello
    p 'hello!!'
  end

  # 後からhelloをprivateにする
  private_class_method :hello
end

# User6.hello

class User7
  # weight は恥ずかしいから公開したくない！
  attr_reader :name

  def initialize(name, weight)
    @name = name
    @weight = weight
  end

  # ユーザ同士の体重を比較する
  def heavier_than?(other_user)
    other_user.weight < @weight
  end

  # protectedメソッドなので同じクラスかサブクラスであればレシーバ付きで呼び出せる
  
  protected

  def weight
    @weight
  end
end

mike = User7.new('mike', 50)
neko = User7.new('neko', 70)
p mike.heavier_than?(neko)
# p mike.weight

class Mike
  NEKO = 'cat'
end

p Mike::NEKO

class Product4
  # クラスインスタンス変数
  @name = 'product'

  def self.name
    # これはクラスインスタンス変数をよんでる
    @name
  end

  def initialize(name)
    # これは前々から説明してたインスタンス変数
    @name
  end

  def name
    # これも同じくインスタンス変数
    @name
  end
end

p Product4.name

class Product4
  # @@ に変えただけ！
  @@name = 'product'

  def self.name
    # 呼び出しはクラスメソッドだろうとインスタンスメソッドだろうと@@
    @@name
  end

  def initialize(name)
    @@name = name
  end

  def name
    @@name
  end
end

class DVD4 < Product4
  @@name = 'DVD'

  def initialize(name)
    @@name = name
  end

  def self.name
    @@name
  end

  def upcase_name
    @@name.upcase
  end
end

# DVD4を定義した瞬間に、Product4の内容もDVDに変わる！！
# 同じものを参照している
p Product4.name
p DVD4.name

# 逆も同じ
product = Product4.new('mike')
p Product4.name
p DVD4.name

class User8
  def hello
    p 'Hello!'
  end

  alias greething hello
end

user = User8.new()
user.greething

class Product5
  def ==(other)
    if other.is_a?(Product)
      code == other.code
    else
      false
    end
  end
end

a = 'abc'
b = 'abc'
p a.equal?(b)

c = a
p a.equal?(c)

p 1 == 1.0

p 1.eql?(1.0)

class String
  def shuffle
    chars.shuffle.join
  end
end

s = 'Hello, I am Alice.'
p s.shuffle

s = 'mikeneko'

# Stringクラスはsplirtメソッドを持つか？
p s.respond_to?(:split)
p s.respond_to?(:name)