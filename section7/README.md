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

## RDocでAPIドキュメントを作成する
* RubyにはコードからAPIドキュメントを生成するRDocというツールが付属している。
* scalaのparadoxみたいにコードにコメント書いて、それをブラウザ上からいい感じに見れるよ
* `rdoc lib/gate.rb` みたいな感じでやると、docディレクトリ以下にHTMLファイルが生成されそれを見るとRDoc形式で見ることができる
* gate.rb に書いてみたよ！

```ruby
Parsing sources...
100% [ 1/ 1]  lib/gate.rb

Generating Darkfish format into /***/ruby_test/section7/doc...

  Files:      1

  Classes:    1 (1 undocumented)
  Modules:    0 (0 undocumented)
  Constants:  0 (0 undocumented)
  Attributes: 0 (0 undocumented)
  Methods:    4 (1 undocumented)

  Total:      5 (2 undocumented)
   60.00% documented

  Elapsed: 0.9s

doc/Gate.html
```

# self
* Rubyのインスタンス自信を表すメソッド。Javaとかのthisと同じだよ
* メソッド内からメソッドを呼び出す時、暗黙的にこのselfが呼ばれている

```ruby
class User
  attr_accessor :name

  def initialize(name)
    @name = name
  end

# これらは全部同じ
  name
  self.name
  @name
end
```

* セッターメソッドは、 self が無いとローカル変数だと勘違いされうまくいかない

```ruby
# これは、一番上だけインスタンス変数が変更できない。ローカル変数に代入だと勘違いされる。
  name = 'mi'
  self.name = 'ke'
  @name = 'neko'
```

* newされる位置により、selfの挙動が異なる。
* クラス直下 と クラスメソッド直下 は同じ
* インスタンスメソッド直下 は別。これらはnewされるたびに別のものになる。
* そのため、インスタンスメソッド <=> クラスメソッド の呼び出しは不可能。
* クラス直下からクラスメソッドは同じなので呼べる。ただ、先にクラスメソッドを定義していないと呼べない。rubyは上から単純に読んでいくコードのため。

```ruby
# このselfは別物
class Foo
  def self.piyo
    self
  end

  def hoge
    self
  end
end

# このselfは同じもの
class Foo
  self

  def self.hoge
    self
  end
end

# そのため、クラスからクラスメソッドを呼べる
class Foo
  def self.hoge
  end

  self.hoge
end
```

* とはいえ、呼べないわけではなく呼び方がちゃんとある。
* `クラス名.メソッド` で呼べる
* `self.class.メソッド` でも呼べる

```ruby
class Product
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

# これはクラスメソッド
  def self.format_price(price)
    "#{price}円"
  end

# これはインスタンスメソッドだけどクラスメソッド呼べてる
  def to_s
    formatted_price = Product.format_price(price)
    "name: #{name}, price: #{formatted_price}"
  end
end

product = Product.new("mikeneko", 145)
p product.to_s
```

# クラスの継承
* Rubyの継承は、 `単一継承` 
* 多重継承ににたミックス院という機能もあるが、基本は単一である。
* 例えば、Object クラスを継承しているのは String, Numeric, Array, Hash。1対1の関係。
* Numericの下に、Integer, Float ... などがあり、それらもまた1対1である。
* Object クラスはデフォルトで継承される。クラスを定義して、それにたいして `to_s` 等が呼べるのはObjectクラスを継承しているからである。

```ruby
# 継承しているクラスを確認する
class Hoge
end
hoge = Hoge.new
p hoge.methods.sort
-> [:!, :!=, :!~, :<=>, :==, :===, :=~, :__id__, :__send__, :class, :clone, :define_singleton_method, :display, :dup, :enum_for, :eql?, :equal?, :extend, :freeze, :frozen?, :hash, :inspect, :instance_eval, :instance_exec, :instance_of?, :instance_variable_defined?, :instance_variable_get, :instance_variable_set, :instance_variables, :is_a?, :itself, :kind_of?, :method, :methods, :nil?, :object_id, :pp, :private_methods, :protected_methods, :public_method, :public_methods, :public_send, :remove_instance_variable, :respond_to?, :send, :singleton_class, :singleton_method, :singleton_methods, :taint, :tainted?, :tap, :to_enum, :to_s, :trust, :untaint, :untrust, :untrusted?, :yield_self]
```

* `.class` オブジェクトのクラスを確認する
* `instance_of?` これも同じく確認する。真偽値で確認できる
* `is_a? （エイリアス kind_of?) ` これは継承関係まで確認する。

```ruby
p hoge.class
-> Hoge

# それはHogeクラスのインスタンスか？
p hoge.instance_of?(Hoge)
-> true

# それはObjectクラスまたはObjectクラスを継承しているか？
p hoge.is_a?(Object)
-> true

# 当然Hogeを比較したらそのままtrueが返ってくる
p hoge.is_a?(Hoge)
-> true
```

* 継承は `サブクラス < スーパークラス` で書く

```ruby
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
# name と price は親クラスで定義してあるので書かなくていい
  attr_reader :running_time

  def initialize(name, price, running_time)
    @name = name
    @price = price
    @running_time = running_time
  end
end
dvd = DVD.new('mike!', 10000, 120)

# 呼び出せるよ！
p dvd.name
p dvd.price
p dvd.running_time
```

* `super` : 親クラスの同盟メソッドを呼び出すことができる
* これを使えば、親のinitialize などを子供から利用できるよ！

```ruby
  def initialize(name, price, running_time)
  # こうかける
    super(name, price)
    @running_time = running_time
  end

# 親と引数が同じ場合、完全に省略することも可能
  def initialize(name, price, running_time)
  # こうかける
    super
  
  # こうかくと、引数無しとみられてエラーになるから注意！
    super()
  end
```

* また、そもそも親と子で実行する処理が変わらなければ、サブクラスで同盟メソッドを定義したりsuperを呼ぶ必要なし
* 同じメソッド名を使うと、オーバーライドしている状態で使わなければ親のクラスが呼ばれる。
* オーバーライドしてる時に、親を呼ぶ方法が `super` なだけ。
* 次のようにオシャレに使うことができる。子供で、親に追加したい要素をsuperの後に着けてあげる感じ。

```ruby
class Product3
end

product = Product3.new()
p product.to_s
-> "#<Product3:0x00007fffcafc5a68>"

class Product3
  def initialize(name, price)
    @name = name
    @price = price
  end

# to_s が意味不明な文字列返ってくるのでオーバーライドしてみる
# 特に専用構文とか無しに同じ名前で定義すれば上書きできる
  def to_s
    "name: #{name}, price: #{price}"
  end
end

# 更に子供でオーバーライドしてみる
class DVD3 < Product3
  attr_reader :running_time

  def initialize(name, price, running_time)
    super(name, price)
    @running_time = running_time
  end

# 親と共通部分はsuperで呼び出し、残りの部分をくっつけて表示できる！いけてる！
  def to_s
    "#{super}, running_time: #{running_time}"
  end
end
dvd = DVD3.new('mike!', 10000, 120)
p dvd.to_s
-> "name: mike!, price: 10000, running_time: 120"
```

* クラスを継承すると、クラスメソッドも継承される。

```ruby
class Foo
  def self.hello
    "Hello!"
  end
end

class Bar < Foo
end

p Bar.hello
-> "Hello"
```