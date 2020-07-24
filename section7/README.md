# 7章 クラスの作成を理解する
## クラスの宣言
* クラス名は必ず大文字で始める。小文字はルールとしてもうNGで、エラーになる。
* キャメルケースで書くのが一般的

```ruby
class クラス名
end
```

```ruby
class User
end

class OrderItem
end
```

## オブジェクトの作成とinitialize
* `クラス名.new` でオブジェクト化する
* その時に呼び出したいメソッドがあれば、 `initialize` を作っておく。必要なければ無しでOK。
  * Scalaのapplyと同じだ！コンストラクタだね

```ruby
User.new

# new されたときにinitialize を呼ぶ
class User
  def initialize
    p 'Initialized.'
  end
end

User.new
```

* initializeメソッドは外部から呼び出すことができない。デフォでprivateメソッドになってる
  * Scalaのapplyは呼べた気がするけど、あれはコンパニオンオブジェクトだったからかな
* initializeメソッドに引数があると、newを呼ぶときに引数が必要になる

## インスタンス変数とアクセサメソッド
* クラスの内部ではインスタンス変数を使うことができる。インスタンス内で共有される変数。
* `@` で始める。

```ruby
class User
  def initialize(name)
    @name = name
  end

  def hello
    # 呼び出し時も @ つけるよ！
    p "Hello, I am #{@name}"
  end
end

user = User.new("mike")
user.hello
-> "Hello, I am mike"
```

* これとは別の、メソッド内で作成される変数をローカル変数と呼ぶ。メソッド内やブロック内でのみ有効。
* これらは `呼び出されるたびに毎回作成される。` 固定値などは入れない方がよさそうだ。
* ローカル変数はアルファベットの小文字やアンダースコアで始める

```ruby
  def hello
    shuffled_name = @name.chars.shuffle.join
    p "Hello, I am #{shuffled_name}"
  end
```

* インスタンス変数は、クラスの外側から参照することができない。
* 同じく、変更することもできない。変更したい、参照したい場合は専用のメソッドを用意する
* このように、インスタンス変数の値を読み書きするメソッドの事を `アクセサメソッド` という
  * vueとかのゲッターセッターみたいなやつ

```ruby
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
    @name
  end

  # @nameを外部から更新する
  # 書き方違和感すごい！
  def name=(value)
    @name = value
  end
end

user = User.new("mike")
user.name
# 呼び出し方は代入と全く同じ！
user.name = "koko"
user.name
```

* `attr_accessor` : 単純にインスタンス変数の内容を外部から読み書きするのであれば、メソッド定義を省略することができる
* `attr_render` : 読み取りにしたい場合はこっち
* `attr_writer` : 書き込み専用はこっち

```ruby
class User
  # @nameを読み書きするメソッドを自動的に追加
  attr_accessor :name
  ...
end

class User
  # @nameを読み取るメソッドを自動的に追加
  attr_reader :name
  ...
end

class User
  # @nameを書き込むメソッドを自動的に追加
  attr_writer :name
  ...
end

# 複数指定
attr_accessor :name, :age
```

## クラスメソッドの定義
* 普通にメソッドを書くと、インスタンスメソッドとなりnewのされ方により振る舞いをそれぞれかえるようになる
* `self.` ひとつひとつのインスタンスに含まれるデータは使わないメソッドを定義したい場合に使う

```ruby
class クラス名
  def self.クラスメソッド
  end
end

# 複数ある場合はこっちの描き方だと毎回self書かなくていいかも
# ネストは一段深くなるけどね
class クラス名
  class self
    def クラスメソッド
    end
  end
end
```

* クラスメソッドの呼び出し方は、 `クラス名.メソッド名`

```ruby
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
```

表記方法
* `クラス名#メソッド名` : インスタンスメソッドを表す場合
* `クラス名.メソッド名` または `クラス名::メソッド名` : クラスメソッドを表す場合

## 定数
* クラス内には定数を書ける。
* `全部大文字` で書く

```ruby
class クラス名
  DEFAULT_PRICE = 0
  ...

  def initialize(name, price = DEFAULT_PRICE)
    @name = name
    @price = price
    # メソッド内からでも呼べる
    p DEFAULT_PRICE
  end
end
```