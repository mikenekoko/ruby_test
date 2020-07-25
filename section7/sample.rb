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
