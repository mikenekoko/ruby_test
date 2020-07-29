# 8章 モジュール
* 継承を使わずにクラスにインスタンスメソッドを追加する
* 複数クラスに対し、共通の得意メソッドを追加する
* クラス名や定数名の衝突を防ぐために名前空間を作る
* 関数的メソッドを定義する
* シングルトンオブジェクトのように扱って設定値などを保持する。

```ruby
module モジュール名
end

module Greeter
  def hello
    'hello'
  end
end
```

クラスと書き方は同じだが、以下の特徴がある
* インスタンスを作成することはできない
* 他のモジュールやクラスを継承することはできない

継承を使えないが、処理が共通化したい時に使う
* `製品` クラスと `ユーザー` クラスがあったとする
* それらは、ログを送信するというメソッドを持つ
* `製品 == ユーザー` の関係は成り立たないので、継承はできない。
* 処理を共通化したい場合に、モジュールを使う
* `include` を使う。これをミックスインという。vueと同じ。

```ruby
module Loggable
  def log(text)
    p "[LOG] #{text}"
  end
end

class Product
  # include で Loggable モジュールをミックスイン
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
```

* このままだと public メソッドで直接呼べてしまうので、privateにした方がいい

```ruby
module Loggable
  private
  def log(text)
    p "[LOG] #{text}"
  end
end
```

* `extend` もう一つのミックスイン方法で、こっちは特異メソッドとしてミックスインする
* そのため、クラスメソッドから呼べるようにできる。includeはインスタンスメソッドだよ！

```ruby
class Product
  # include で Loggable モジュールをinclude
  extend Loggable

  def self.title
    log "mike!"
  end
end
```

# モジュールについてもっと詳しく
## モジュールの確認
* `include?(モジュール名)`  で、対象のモジュールがmixinされているか確認できる
* `is_a?(モジュール名)` でも可能。

## include先のメソッドを使うモジュール
* ダックタイピングで説明したように、moduleでも同じように～～がある前提のようなコードが書ける

## Enumerableモジュール
* おなじみ、mapとか入ってるあれ。これもモジュールだよ
* Enumerableモジュールは each を使っており（ダックタイピング）、 each があればEnumerableをincludeして使うことができる！

## Comparableモジュール と <=> 演算子
* 名前の通り、比較モジュール
* `< <= == > >= between?` などが使えるのはこれをincludeしているから。
* `<=>演算子` が使えるならば、Comparableモジュールをincludeして使うことができる

```ruby
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

# 比較ができるようになる！
p t_120 > t_150
p t_120 <= t_150
p t_120 == t_150
false
true
false
```

## Kernelモジュール
* 当たり前のように使えてるあれやこれを提供してくれているモジュール
* `puts p print require loop` など
* Object が Kernel モジュールをincludeしているから呼び出せる
* クラスなども含め、すべてが Object に属するので全てから呼び出せるというわけ。実質グローバルメソッドということ。

```ruby
p Object.include?(Kernel)
-> true
```

## オブジェクトに直接ミックスインする

```ruby
s = 'abc'
s.extend(Loggable)
# 通常呼べないが、extendすることで呼べるようになる
s.log('Hello')
```

# モジュールを利用した名前空間の作成
* クラス名が衝突するのを避ける方法
* モジュール構文の中にクラス構文を埋め込み、そのモジュールに属するクラスという意味にし同じクラス名でも衝突させない
* `モジュール名::クラス名` で呼ぶ

```ruby
module Baseball
  class Second
  end
end

module Clock
  class Second
  end
end
-> 同じ Second　クラスだが衝突しない！

Baseball::Second.new()
Clock::Second.new()
```

* 既にモジュールがある場合、追加できる

```ruby
module Baseball
end

class Baseball::Second
end
```

* トップレベルの参照は `モジュール名無し::モジュール名` になる。 トップレベルに `Second` があるならば `::Second`

# 関数や定数を提供するモジュールの作成
* クラスに組み込まなくても、直接モジュールのメソッドを呼び出したいと思う場合は、モジュール自身に特異メソッドを定義する
* `モジュール名.メソッド名` で呼べる
* newする必要が全くない、メソッド軍を作るのに有効

```ruby
module Loggable2
  def self.log(text)
    p "[LOG] #{text}"
  end

  # またはこっち。たくさんあるならこっちが便利だよ
  class << self
    def log(text)
      p "[LOG] #{text}"
    end
  end
end

Loggable2.log('Hello');
```

## モジュール関数
* `module_function` を付与することで、特異メソッドでもありmixinできるメソッドにもできる
* 使い方は、 `private` とかと同じで、定義した下に属するメソッドがそれになったり、指定した奴がそうなったりする
* これをモジュール関数と呼ぶ
* `モジュール関数をミックスインすると、自動的にprivateメソッドになる`
  * なんで・・・？

```ruby
module hoge
  def fuga
  end

  module_function :fuga

  # または定義後にメソッド書く
  module_function
  def fuga
  end
end
```

## 状態を保持するモジュール
* APIのURLなど、環境によって変えるものがあるとする。(scalaのconfigみたいな)
* それを毎回クラスなどでnewして引っ張ってくるのはあまりいけていない
* 1つだけそれを作り、それを呼び出すようにした方が都合がいい。それにはモジュールが適している。
* 指定の値情報を保持したモジュールを作り、それを利用するようにする。その方法を、シングルトンオブジェクトという。

```ruby
module AwesomeApi
  @base_url = ''
  @debug_mode = false

  # クラス直下の変数に対してなので、selfで代入する
  class << self
    attr_accessor :base_url, :debug_mode
  end
end
```

## Singletonモジュールを使ってシングルトンオブジェクトを作る
* include して使う。 newがprivateメソッドになり、外部から呼び出せなくなる。
* クラスの特異メソッドとして instanceメソッドが定義され、ここから「唯一、一つだけ」のシングルトンオブジェクトを作ることができる

```ruby
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
-> 同じ値が返ってくる！
```

## 優先度
* 同じメソッド名がモジュールにもクラスにもあった場合、クラスの方が優先度が高い。
* モジュールの方が優先度を高くしたい場合、 include ではなく `prepend` を使う
* super は、通常クラス -> モジュール に向くが、 prepend を使うと逆向きになる。

## 有効範囲を限定（refinements）
* `refine` を使うと、モンキーパッチなどにより全体に影響が出るのを防ぐことができる
* 独自の有効範囲を指定することができる
* `refine クラス do` で指定

```ruby
module StringShuffle
# String クラスに対してrefinements
  refine String do
    def shuffle
      chars.shuffle.join
    end
  end
end
```

* refinements を有効にするためには `using` というメソッドを使う
* 使用したいクラス内で、使用したいモジュールを定義することができ影響を絞り込めることができる

```ruby
module StringShuffle
  refine String do
    def shuffle
      chars.shuffle.join
    end
  end
end

# 通常shuffleは呼ぶことができない
'Alice'.shuffle
-> error

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
```

* トップレベルに置くことができ、そうした場合はその書いた場所からファイルの末尾まで有効になる

```ruby
require './string_shuffle'

using StringShuffle
'Alice'.shuffle

class User3
  def initialize(name)
    @name = name
  end

  def shuffled_name
  # using をクラス内で個別にしなくてもトップレベルでやってるので呼び出せる
    @name.shuffle
  end
end
```

* Ruby 2.4 からはクラスだけでなくモジュールにもrefineできるようになっている