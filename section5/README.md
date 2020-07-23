# 5章 ハッシュ
* 定義方法は全部perlと同じなので割愛する

```ruby
currencies = { 'japan' => 'yen', 'us' => 'dollar', 'india' => 'rupee' }

# ハッシュを使った繰り返し処理
currencies.each do |key, value|
  p "#{key} : #{value}"
end

# 1つにしても取れる
currencies.each do |key_value|
  p "#{key_value[0]} : #{key_value[1]}"
end

# 削除はdelete。削除したvalueが返ってくる
currencies.delete('japan')
-> 'yen'

# なかったらブロック引数を呼ぶみたいなのもできる
currencies.delete('japan') { |key| "Not found: #{key} }
```

# シンボル
* シンボルを表すクラスであり、任意の文字列と1対1に対応するオブジェクト
* 同じ内容のシンボルは必ず同一のオブジェクトである
* イミュータブルオブジェクトであるため、破壊的な変更はできない。そのため、keyに向いている。
* `:シンボル名` で書く。 throw~catch のタグと同じ書き方

```ruby
# クラスは Symbol
':apple'.class
-> Symbol

# 中身は文字列ではなく、整数値のため比較が文字列より早い
'apple' == 'apple' # 遅い
:apple == :apple # 早い

# hashのkeyにする場合、囲まなくていい
currencies[:apple]

# こんな感じでメソッドが見れるが、メソッド名が全部シンボルで作られているのが確認できる
p 'apple'.methods
p :apple.methods
```

利点
* 表面上は文字列っぽいので理解が容易
* 内部的には整数なので高速で動作する
* 同じシンボルは同じオブジェクトであるたメモリ効率がいい
* イミュータブルなので勝手に変えられないためkeyに向いている

## ハッシュについてもっと詳しく

```ruby
# シンボルがキーのハッシュを作る場合、省略記号で書ける
# コロンの位置が右側なのに注意！
currencies = { 'japan' => 'yen', 'us' => 'dollar', 'india' => 'rupee' }
currencies = { japan: 'yen', us: 'dollar', india: 'rupee' }
-> {:japan=>"yen", :us=>"dollar", :india=>"rupee"}

# スペース空いてるとエラーになるよ
currencies = { japan : 'yen', us: 'dollar', india: 'rupee' }

# keyもvalueもシンボルだとこう
currencies = { japan: :yen, us: :dollar, india: :rupee }
-> {:japan=>:yen, :us=>:dollar, :india=>:rupee}
```

## メソッド名にシンボルを使うことで、説明変数のように使える
* 可読性向上手段

```ruby
# こんなメソッドがあったとして
def buy_burger(menu, drink, potato)
  # ハンバーガー購入
  if drink
    # ドリンク購入
  end
  if potato
    # ポテト購入
  end
end

# 呼び出しだとよくわからない
buy_burger('cheese', true, true)

# こうすることで引数の役割が明確になる
# 呼び出し時にシンボルの指定も必須になる
def buy_burger(menu, drink:, potato:)
buy_burger('cheese', drink: true, potato: true)

# 初期値指定としても使える
def buy_burger(menu, drink: true, potato: true)
buy_burger('cheese', potato: true)
buy_burger('cheese')

# キーワード引数は呼び出し時に順番を自由に入れ替えることができる
buy_burger('cheese', potato: true, drink: true)

# キーワード引数と一致するハッシュであれば、メソッドの引数として渡すことができる
params = { drink: true, potato: true }
buy_burger('fish', params)
```

* 面白い！perlよりもハッシュの扱いがとても強力だ。
* キーワード引数とハッシュの関係が面白いし、覚えてるとコードがぐっと短くなりそうなのでもっと活用していきたい

## keys
* ハッシュのキーを配列として返す

```ruby
currencies = { japan: 'yen', us: 'dollar', india: 'rupee' }
currencies.keys
-> [:japan, :us, :india]
```

## values
* ↑の値バージョン

## has_key? (エイリアス keys? include? member?)
* エイリアスが多いが、どれも同じ。 has_key? が元でその他全部これのエイリアスメソッド
* ハッシュの中に指定されたキーが存在するかどうか確認するメソッド

```ruby
p currencies.has_key?(:japan)
-> true
p currencies.has_key?(:italy)
-> false
```

## ** でハッシュを展開させる
* `**` をハッシュの前に着けるとハッシュリテラル内で他のハッシュのキーと値を展開することができる

```ruby
currencies = { japan: 'yen', us: 'dollar', india: 'rupee' }
hoge = { hoge: 'fuga', **currencies }
p hoge

# merge メソッドを使っても同じことができるよ
hoge = { hoge: 'fuga' }.merge(h)
```

## ハッシュを使った疑似キーワード引数
* キーワード引数は比較的新しい書き方で、古い書き方はこんな感じだった
* 古いコードとかだと登場してくると思うので覚えておこう

```ruby
def buy_burger(menu, options = {})
  drink = options[:drink]
  potato = options[:potato]
end

buy_burger('cheese', drink: true, potato: true)
```

* 呼び出し方は同じだが、メソッドの引数の受け取り方と展開の仕方がちょっと違う
* これによる弊害は、存在しないキーワードを呼び出し時に設定してもエラーではじけないところ。エラー処理をベット書く必要がある。
* これから書く場合はキーワード引数がいいよ！

## 任意のキーワードを受け取る**引数
```ruby
def buy_burger(menu, drink: true, potato: true, **others)
  # others はハッシュとして渡される
  p others
end

buy_burger('cheese', drink: true, potato: true, saled: true, chicken: false)
-> saledとchickenがハッシュとして渡される
```

## メソッド呼び出し時の{}省略
* 最後の引数がハッシュであればハッシュリテラルの{}を省略できる
* 最後じゃないとエラーになる！

```ruby
# こんなメソッドがあったとして
def buy_burger(menu, options = {})
  p options
end

# ハッシュを第二引数として呼び出すなら省略できる
buy_burger('cheese', { 'drink' => true, 'potato' => true } )
buy_burger('cheese', 'drink' => true, 'potato' => true)
buy_burger('cheese', drink: true, potato: true)
```

## ハッシュと配列の変換
* `to_h` : ハッシュ -> 配列
* `to_a` : 配列 -> ハッシュ

```ruby
currencies = { 'japan' => 'yen', 'us' => 'dollar', 'india' => 'rupee' }
p currencies.to_a
-> [["japan", "yen"], ["us", "dollar"], ["india", "rupee"]]

currencies = [["japan", "yen"], ["us", "dollar"], ["india", "rupee"]]
p currencies.to_h
-> {"japan"=>"yen", "us"=>"dollar", "india"=>"rupee"}

# 古いやり方 (Hash[]を使う)
currencies = [["japan", "yen"], ["us", "dollar"], ["india", "rupee"]]
Hash[array]
-> {"japan"=>"yen", "us"=>"dollar", "india"=>"rupee"}

# キーと配列が交互に並ぶフラットな配列をsplat展開してもいい
currencies = [:japan, "yen", :us, "dollar", :india, "rupee"]]
Hash[*array]
-> {"japan"=>"yen", "us"=>"dollar", "india"=>"rupee"}
```

* 古い書き方だと `Hash` で書かれているパターンも多いから覚えておこう

## ハッシュの初期値
* ないkeyを指定するとnilが返ってくるが、 Hash.new() で作ると初期値を指定できる
```ruby
h = Hash.new('Hello')
h:[:foo]
-> "Hello"

# ないkeyを指定した場合に、そのkeyと初期値valueを追加する
h = Hash.new { |hash, key| hash[key] = 'Hello' }
h[:foo] -> "hello"
h
-> { :foo => "Hello" }
```

# シンボルについてもっと詳しく
## NGな書き方と回避方法
* ハイフンとか、数値で始まるのはNG `:123` `:ruby-is-fun`
* シングルクォートでくくると一応使える `:'123'` `:'ruby-is-fun'`
  * コロンはくくらない点に注意！

```ruby
:'12345'
:'ruby-is-fun'
:'perl-is-bad'
```

## シングルクォートの代わりにダブルを使うことで展開しつつシンボルとして使える

```ruby
alice = 'alice'
:"#{alice.apcase}"
-> :ALICE
```

## %記法でシンボルやシンボルの配列を作成する
* 配列でもでてきた%記法、これのシンボル版がある
* `%s` シンボルの作成
* `%i` シンボルの配列の作成。空白が区切り文字になる
* `%I` 改行文字や式展開を使いたい場合はこっち

```ruby
%s!ruby is fun!
-> :"ruby is fun"

%i(apple orange melon)
-> [:apple, :orange, :melon]
```

## シンボルと文字列の関係
* 見た目は似ているが扱いは別なので、 += とかで合体させるのはできない
* `to_sym` で文字列をシンボルに変換できる
* `to_s` でシンボルを文字列に変換できる

```ruby
string = 'apple'
symbol = :apple

string == symbol
-> false
string.to_sym == symbol
string == symbol.to_s
-> true
```

# コラム
## 条件分岐で変数に代入
* `&.` メソッドを呼び出されたオブジェクトがnil出ない場合はその結果を、nilだった場合はnilを返す
* nil でなければ～～のようなif文が必要なくなる！

```ruby
# upcaseはnilに対して呼べないためこうするが
hoge.upcase if hoge

# &演算子を使うと行けてる感じで書ける！
hoge&.upcase
-> nilの場合はnilが返ってくるのみでエラーにならない
```

## || = で代入
* これはperlでも使ってたやり方。左辺が偽であるならば右側の値を入れる

```ruby
hoge = nil
hoge ||= 10
```

## !! でtrue/falseで返すようにする
* `～～?` で定義した自分のメソッドを、true/falseで返したいとする。そういった時に使える。
* 否定の否定で、trueかfalseにして返してくれる。

```ruby
# find_user が nil とかで返ってくるものとして、それを真偽値で返すメソッド
def user_exists?
  user = find_user
  find_user ? true : false
end

# こうかける
def user_exists?
  !!find_user
end
```

結構perlと似てるところやっぱり多い。
でもこっちの方が機能が多いし、シンボルなど覚えることが多いので間違えそうだ。
どこがどうperlと違うのかしっかり覚えていきたいね