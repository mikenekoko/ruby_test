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