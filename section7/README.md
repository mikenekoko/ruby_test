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

# メソッドの公開レベル
## public
* クラスの外部からでも自由に呼び出せるメソッド
* `public` という記述を書き、その下に属するメソッドが全てpublicメソッドになる。
* initialize 以外はデフォルトでこれ。呼び出せる理由はこれになってるから

## private
* クラス内部からでのみ呼び出せるメソッド
* `private` という記述を書き、その下に属するメソッドが全てprivateメソッドになる。
* 正確には、レシーバを指定して呼び出すことができないメソッド
  * レシーバは、 `user.hello` だとしたら user が対象になる。
  * レシーバを指定できないため、privateメソッドを `self.hello` と呼ぶとエラーになる。 `hello` と直で呼べばOK
* rubyでは、privateメソッドは `サブクラスでも呼び出せる`
  * オーバーライドも可能。ここはrubyの特徴的な点
* `private :メソッド名` で個別にprivateメソッドを指定する事も可 

```ruby
class User
  def hoge
    p "hoge"
  end
# これ以下のメソッドは全部プライベートメソッド
  private

# これはプライベート
  def hello
    p "hello"
  end

# あとから hoge をprivateにする
  private :hoge
end
```

* クラスメソッドは、private宣言の下に書いただけではプライベートメソッドにならない。
* `class << self` 構文を使う
* または、 `private_class_method :メソッド名` でクラスメソッドの定義後に公開レベルを変える

```ruby
class User5
  class << self
    private

    def hello
      p 'hello!!'
    end
  end
end

User5.hello
-> privateのため呼び出せない

class User6
  def hello
    p 'hello!!'
  end

  # 後からhelloをprivateにする
  private_class_method :hello
end

User6.hello
-> 同じく
```

## protected
* そのメソッドを定義したクラス自身と、サブクラスのインスタンスメソッドから `レシーバ付きで` 呼び出せる
* 外部には後悔したくないが、同じクラスやサブクラスの中であればレシーバ付きで呼び出せるようにしたい！という用途で使う
* `protected` という記述を書き、その下に属するメソッドが全てprotectedメソッドになる。
* 単純なゲッターであれば、 `protected :サブクラス名`  でもいい

```ruby
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

  # protected :weight でも同じ
end

mike = User7.new('mike', 50)
neko = User7.new('neko', 70)
p mike.heavier_than?(neko)
-> 呼び出せる！
p mike.weight
-> 直接はエラーになる
-> sample.rb:247:in `<main>': protected method `weight' called for #<User7:0x00007fffca56d2f0 @name="mike", @weight=50> (NoMethodError)
```

# 定数についてもっと詳しく
* 定数は `クラスの外部から直接参照可能！！`
* 呼び出し方は `クラス名::定数名`
* クラス外部から呼び出されたくない場合は `private_constant :定数名` で指定
* 定数はメソッド内部で作成することはできない。

```ruby
class Mike
  NEKO = 'cat'
end

p Mike::NEKO
```

## 再代入
* 定数は `再代入が可能。` 警告は出るけど。
* 再代入を防ぐには `freeze` (凍結) を使う

```ruby
class Hoge
  MIKE = 'neko'
  MIKE = 'mikeneko'
end

Hoge::MIKE = 'noraneko'

# クラス丸ごと凍結
Hoge.freeze
class Hoge
  MIKE = 'neko'
  # 定数定義後に書く
  freeze
  MIKE = 'mikeneko'
  -> エラー
end

# 定数単体で凍結
HOGE = 'hoge'.freeze
```

* `upcase!` みたいなミュータブルメソッドを呼ぶとそのまま定数が破壊変更されるので気を付ける事
* 各種freezeするしかないが、どこまでやるかは要件に応じて検討するように！
  * これ決めんのむずそうだな

```ruby
# 無かったらHOGEの定数を使うが、破壊的変更をしているため定数の中身が消える
# こういうパターンめっちゃ気づきづらいから気をつけてな
def hoge(names = HOGE)
  name.delete('foo')
end

# これとかも安心そうだけど、配列やハッシュそのものは凍結したけど各要素は凍結していないので変更できてしまう
class Fuga 
  HOGE = ['ho', 'ge']
end

Fuga::HOGE[0].upcase!

# 各要素全部freezeするしかない。mapとか使うとスマートに書ける
HOGE = ['ho', 'ge'].map(&:.freeze).freeze
```

* true/false や 数値みたいなものはイミュータブルなため、freezeする必要がない事を覚えておこう！

# 様々な種類の変数
* これから紹介するのはあんまり使用頻度が高くない奴らだよ
* チラッと覚えておいて、使うタイミングがあったら読み直すくらいでOK。引き出し増やしとこう

## クラスインスタンス変数
* クラスに設定されるインスタンス変数。クラスメソッドからインスタンス変数を呼ぶとこっちが呼ばれる。
* インスタンス変数は継承関係に応じて親と子で内容が共有されるが、クラスインスタンス変数は親と子でそれぞれ個別である

```ruby
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
-> "product"
```

## クラス変数
* `@@` でクラス直下に定義した変数をクラス変数という
* 全く同じもののため、継承した親や子で変えたりすると継承関係にあるものも変わる。

```ruby
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
-> DVD
p DVD4.name
-> DVD

# 逆も同じ
product = Product4.new('mike')
p Product4.name
-> mike
p DVD4.name
-> mike
```

* クラス内定数みたいなイメージでいいんかな？
* ライブラリ(gem)の設定情報(config)を格納する場合などに使われるケースがある

## グローバル変数
* `$` で定義すると、グローバル変数になりクラス内部外部問わず呼び出せる
* perlの @とか$ と全然意味違うから違和感すごい
* あまり使うべきではないし、バグのもとかつ可読性悪いのでできる限り使わないのを非推奨

```ruby
$hoge = 'hoge'

class Hoge
  def initialize(name)
  # そのまま指定とか代入できるよ
    $hoge = name
  end
end
```

# クラス定義やRubyの言語使用に関する高度な話題
## エイリアスメソッドの定義
* 例えば、 `size` は `length` のエイリアスメソッド。この size を自作できる
* `alias 新しい名前 元の名前` で定義。クラス内に書く。

```ruby
class User8
  def hello
    p 'Hello!'
  end

  alias greething hello
end

user = User8.new()
user.greething
-> Hello!
```

## メソッドの削除
* `undef 削除するメソッド名` で削除できる。クラス内に書く。

## ネストしたクラス定義
* クラスはネストさせることが可能
* `クラス名1::クラス名2` で呼べる
* クラス名の予期せぬ衝突を防ぐ、名前空間を作る場合によく使われる

```ruby
class クラス名1
  class クラス名2
  end
end
```

## 演算子の挙動を独自に再定義する
* 前やったように、 `name=(value)` とかで代入処理をオーバーライドできる
* そんな感じで、他にも色々ある。 `| ^ & <= => ...`

```ruby
class Product5
  def ==(other)
    if other.is_a?(Product)
      code == other.code
    else
      false
    end
  end
end

a = Product5.new...
b = Product5.new...

# これはオーバーライドした方のメソッドを呼んでる
a == b

# メソッドなのでこんな感じでも呼べる。流石に使われない。
a.==(b)
```

## 等値を判断するメソッドや演算子の挙動を学ぶ
### equal?
* object_id が等しい場合にtrueを返す。完全に同じインスタンスかどうかを判断する場合に使われる
* このメソッドを再定義するとプログラムに悪影響を及ぼすのでNG

```ruby
a = 'abc'
b = 'abc'
p a.equal?(b)

c = a
p a.equal?(c)
```

### ==
* オブジェクトの内容が等しいかどうかを判断する
* たとえば、 `1 == 1.0` は trueになる
* さっきやったみたいに再定義してもOK

### eql?
* ハッシュのキーとして、2つのオブジェクトが等しいかどうかを判断する
* `1 == 1.0` はtrueであったとしても、 キーとして見たときはそれは異なるキーとして扱われる。
* そういった判断ケースで使われる

```ruby
p 1.eql?(1.0)
```

* 再定義も可能だが、 `a.eql?(b)` が真ならば、 `a.hash == b.hash` が成り立つようにhashメソッドも再定義する必要がある

### ===
* case文のwhen句で使われる。デフォルトだと省略されている。
  * `when節のオブジェクト === case節のオブジェクト`
* javascriptだと正確比較なので違和感

```ruby
text = 'mike'
case text
# 内部的には、 'mi' === text をしている
when 'mi'
when 'mike'
end
```

* 型での比較もできるのでこんなこともできる
* 独自に定義したオブジェクトだと、型比較できないのでその場合は === を再定義すること

```ruby
text = ['mike', 'neko']
case text
when String
when Array
end
```

## オープンクラスとモンキーパッチ
* Rubyのクラスは変更OKのオープンなので、 `オープンクラス` と呼ばれたりする
* 同じクラスを定義した場合、前の部分を引き継ぐという特性があるため簡単にメソッドを追加したりできる
* Rails とかも、デフォにないrubyのメソッドをオープンクラスを使ってはやしまくってたりする

```ruby
class String
# shuffle という独自メソッドをはやす
  def shuffle
    chars.shuffle.join
  end
end

s = 'Hello, I am Alice.'
p s.shuffle
-> "ac ele, IolAHml .i"
```

* 既存のメソッドの挙動を、自分が期待する挙動に変更することを `モンキーパッチ` という
* 直接上書きしたり、 `alias` を使って既存のメソッドをエイリアスメソッドとして残したりとか色々できる。
* モンキーパッチの変更スコープは `グローバル` なため注意すること。

こんな感じの弊害も起きるので気を付ける事
* デフォのメソッドを上書きした結果、全体に影響が出た
* 標準クラスに独自メソッドを追加したが、自分以外使い方がわからず負債となる
* 外部ライブラリのコードにモンキーパッチを当てて使っていたが、バージョンをあげた際に整合性が取れなくなりエラーになる

そのため、乱用せずモンキーパッチなどを使わずに要件が満たせないか最大限考える

## 特異メソッド
* オブジェクト単位で挙動を変えることもでき、 `得意メソッド` と呼ぶ。
* `オブジェクト.メソッド名` で定義できる。そのオブジェクトしか影響を受けない。

```ruby
alice = 'Hello, I am Alice.'

def alice.shuffle
  chars.shuffle.join
end

# こうでもかける
class << alice
  def shuffle
    chars.shuffle.join
  end
end

s = 'Hello, I am Alice.'
p s.shuffle
-> "ac ele, IolAHml .i"
```

## クラスメソッドも特異メソッド！
* 書き方が似ているように、クラスメソッドも特異メソッドである。
* `self` というオブジェクトに専用のメソッドをはやしているだけ。

```ruby
# こう書けばクラスメソッドが特異メソッドであることがわかりやすい
class User
end

def User.hello
  "hello!"
end
```

## ダックタイピング
* オブジェクトのクラスがなんであろうと、そのメソッドが呼び出されば良しとする考え
* 「アヒルのように歩き、アヒルのように鳴くならばアヒルである」という言葉に由来するプログラミング言語 -> 初耳
* 動的型付け言語の非常に強力な機能なため覚えよう！！

```ruby
# userからnameが呼べたらOKなメソッド
# そのuserがどんな実装であろうと、呼べれば気にしない
def A(user)
  user.name
end
```

* 親クラスに、子クラスで実装される前提のメソッドを使って定義とかもできる
* 親クラスからそれを呼ぶとエラーにはなる。わかりづらいので、親でそのメソッドを読んだ時にUsageみたいなのを raise で返すのはあり

# コラム
## respond_to?
* メソッドの有無を調べる。ダックタイピングなどの確認分岐相性がいい

```ruby
s = 'mikeneko'

# Stringクラスはsplirtメソッドを持つか？
p s.respond_to?(:split)
-> true
p s.respond_to?(:name)
-> false
```

## Rubyでメソッドのオーバーロード？（多重定義）
* 他言語では、引数の型によって動作を変える定義ができる
* rubyでは、文字列や数値を変換するメソッドが柔軟に備わっているためこの考え方はない。デフォルト引数などもあるため。
