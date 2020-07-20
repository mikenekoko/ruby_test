# 4章 配列
rubyの配列は他言語とちょっと違うので気を付けてね

```ruby
# 最後の要素にカンマがついててもOK
a = [
  1,
  2,
  3,
]

# 異なるデータ方でも混在してOK
a = [1, 'hoge', 3]

# 多重配列もOK
a = [ [1, 2, 3], [4, 5, 6] ]

# 取り出し方はよくある感じ
a = [1, 2, 3]
a[0] -> 1

# 存在しない要素は nil で返ってきてエラーにはならない
a[5] -> nil

# 長さ取得は size か length。 length は内部で size を呼んでいるエイリアスメソッドのため全く同じ。sizeの方がいいのかも
a.size
a.length

# 値代入
a[0] = 20

# ないところに入れると、間の値はnilで埋まる
a[4] = 50
-> a = [20,2,3,nil,50]

# << を使うと、配列の一番最後に入れることができる！これはruby独自っぽい
a = []
a << 1
-> a = [1]

# 配列内の特定一の要素を削除するには、 delete_at メソッドを使う
a = [1,2,3]
a.delete_at(1)
-> a = [1,3]

# 存在しない添え字を削除しようとするとnilが返ってくる。成功すると削除した値が返ってくる
a.delete_at(100)
-> nil
a.delete_at(0)
-> 1

# 変数を使った多重代入。以下は同じ意味
a, b = 1, 2
a, b = [1, 2]

# 多いと切り捨てられ、少ないとnilが入る
c, d = [10]
c -> 10
d -> nil

e, f = [1, 2, 3]
e -> 1
f -> 2

# 配列で返ってくるメソッドだった場合、個別に受け取ったほうが楽になる
# divmod という、割り算の省都余りを配列として返すメソッドを使ってみる
quo_rem = 14.divmod(3)
"商=#{quo_rem[0]},余り=#{quo_rem[1]}"

## こう書いた方がいい
quotient, remainder = 14.divmod(3)
"商=#{quotient},余り=#{remainder}"
```

# ブロックの話
* rubyでは、for文はあるけどほとんど使われない。
* rubyの場合、配列自体に対して「繰り返せ」という命令を送る。それがeachメソッド

```ruby
numbers = [1,2,3,4]
sum = 0
numbers.each do |n|
  sum += n
end

print sum
-> 10
```

* これは、配列自体に組み込み関数として each があり、それを呼び出している。
* eachメソッドの役割は、配列の要素を最初から最後まで順番に取り出すこと。取り出すだけ。
* 取り出した要素をどう扱うかが後ろに書いてある。そこで登場するのがブロックで、 `do から end までがブロック` になる
* `|n|` はブロック引数と呼ばれるもので、eachメソッドから渡された配列の要素が入る。 1,2,3,4 が順番に渡される
* あとは書いてある通り、 sum += n が実行される
* 面白い書き方だけどやってることはまぁ理解できる。

#### delete してみる
配列には指定した値に一致する要素を削除するdeleteメソッドがある

```ruby
a = [1,2,3,1,2,3]
a.delete(2)
# -> [1,3,1,3]
```

これは直接指定したものしか消せないので、奇数の場合消すといったものをつくってみる
`delete_if` メソッドを使う

```ruby
a = [1,2,3,1,2,3]
a.delete_if do |n|
  n.odd?
end

print a
# -> [2,2]
```

* delete_if は、ブロックを使い true が返ってきたらそれを削除する
* odd? で、奇数であればtrueが返ってきて、それで削除してくれている

色々ブロック要素

```ruby
# ブロック引数は別に n じゃなくて好きなのでOK
numbers.each do |n|
  sum += n
end

# 使わない場合、省略OK
numbers.each do
  sum += 1
end

# こんな感じでブロック内部は自由に書いてOK。偶数のみ10倍にするならこんな感じ
numbers.each do |n|
  sum_value = n.even? ? n*10 : n
  sum += sum_value
end

print sum
-> 64

# ブロック内部の変数はブロック外から呼ぶことはできない
numbers.each do |n|
  sum_value = n.even? ? n*10 : n
  sum += sum_value
end

print sum_value
-> Traceback (most recent call last):
sample.rb:28:in `<main>': undefined local variable or method `sum_value' for main:Object (NameError)'

# 同じ変数名だと、スコープが狭いほうが優先される。同じ名前は混乱するので使わない方がいい
```

# do...end と {}
* do...end ともう一つ、 `{}` でブロックを作成することができる。
* こちらはワンライナーで書いても結構わかりやすいみたいな利点がある

```ruby
# 以下は同じ意
numbers.each do |n| sum += n end
numbers.each { |n| sum += n } 

numbers.each do |n|
  sum += n
end
numbers.each { |n|
  sum += n
}
```

* 使い分けは、改行を含む永井ブロックを書く場合は `do...end` で一行の場合は `{}` とされるケースが多い

# 色々ブロックを使うメソッド
## map(エイリアス collect)
* 各要素に対して、ブロックを評価した結果を新しい配列にして返す

```ruby
# こんな感じの事がやりたいとして
numbers = [1,2,3,4,5]
new_numbers = []
numbers.each { |n| new_numbers << n * 10 }
new_numbers

# mapを使うとこんな感じで書ける

numbers = [1,2,3,4,5]
new_numbers = numbers.map { |n| n * 10 }
```

* 他の配列を使って処理した結果を別の配列に入れていくような処理は全てmapで書ける

## select(エイリアス find_all)
* 各要素に対してブロックを評価し、その戻り値が真の要素を集めた配列を返すメソッド

```ruby
# 偶数だけ返す
numbers = [1,2,3,4,5,6]
even_numbers = numbers.select { |n| n.even? }
-> [2, 4, 6]
```

## reject
* selectの反対。偽の要素を集めた配列を返すメソッド

```ruby
# 偶数だけ返す
numbers = [1,2,3,4,5,6]
even_numbers = numbers.reject { |n| n.even? }
-> [1, 3, 5]
```

## find(エイリアス detect)
* 最初に真になった要素を1つみつけて返す

```ruby
numbers = [1,2,3,4,5,6]
even_number = numbers.find { |n| n.even? }
-> 2
```

## inject(エイリアス reduce)
* 畳み込み演算を行うメソッド

```ruby
# each を使って合計していくメソッド
numbers = [1,2,3,4]
sum = 0
numbers.each { |n| sum += n }
p sum

# inject を使った書き方
numbers = [1,2,3,4]
sum = numbers.inject(0) { |result, n| result + n }
p sum
```

* inject の第一引数は、result と対応しており初回はここに記述した値が入る。最初は `0` が result に入る
* 第二引数の n はいつも通り、配列の値が入ってくる。計算結果が result に入っていく。

1. result = 0, n = 1 で 0 + 1 = 1 がresult に入る
2. result = 1, n = 2 で 1 + 2 = 3 がresult に入る
...

といった形で入っていく。以下の計算をやったのと同じ事になる

```
((((0 + 1) + 2) + 3) + 4)
```

もちろん文字列とかも可能

## & とシンボルを使ってもっと簡潔に書く
* Scalaでいう `_` みたいな感じで使えるっぽい
* `&:メソッド名` という書き方ができる

```ruby
# 以下は同じ
language = ['ruby', 'java', 'perl']
language.map { |s| s.upcase }
language.map(&:upcase)

numbers = [1,2,3,4,5,6]
p numbers.select { |n| n.odd? }
p numbers.select(&:odd?)
```

使える条件

1. ブロック引数が1つだけである
2. ブロック内呼び出すメソッドには引数がない
3. ブロックの中では、ブロック引数に対してメソッドを1回呼び出す以外の処理がない

2と3がScalaの `_` とはちょっと違う感じかな。
条件厳しいけど、シンプルな処理だったら使えるのでむしろその時だけこっちを使うってちゃんと使い分けができそう。

### &が使えないパターン
```ruby
# ブロックの中でメソッドではなく演算子を使っている
[1, 2, 3, 4, 5, 6].select { |n| n % 3 == 0 }

# ブロック内のメソッドで引数を渡している
[9, 10, 11, 12].map { |n| n.to_s(16) }

# ブロックの中で複数の分を実行している
[1, 2, 3, 4].map do |n|
  m = n * 4
  m.to_s
end
```

結構厳しいな…

# 範囲(Range)
* 1から5まで　aからeまで　といった値の範囲を表すオブジェクトがある
* これを範囲オブジェクトと呼び、 `..` または `...` を使って表す

|記号|意味|
|:--:|:--:|
| `最初の値..最後の値` |最後の値を含む|
| `最初の値...最後の値` |最後の値を含まない|

```ruby
# classはrangeクラスになる
(1..5).class
-> range

# 挙動の違い
range = 1..5
p range.include?(4.9)
p range.include?(5)

range = 1...5
p range.include?(4.9)
p range.include?(5)
```

* 4.9 のような値も `範囲の中` であるため入る。イメージは 1,2,3,4,5 だが、1 ~ 5 の間全てが含まれるといったイメージの方が正しい。

範囲オブジェクトを使うと便利なパターン

```ruby
# 指定した範囲だけ取得する
a = [1,2,3,4,5]
p a[1..3]
-> [2,3,4]

b = 'abcdef'
p b[1..3]
-> "bcd"

# n以上m未満 or n以上n以下の判定をする
def liquid?(temprature)
  (0...100).include?(temprature)
end

# caseと合わせる
def charge(age)
  case age
  when 0..5
    0
  when 6..12
    300
  else
    1000
  end
end
```

to_a を呼ぶと配列を作ることができる

```ruby
(1..5).to_a -> [1,2,3,4,5]
('a'..'e') -> [a,b,c,d,e]
('bad'..'bag') -> ["bad","bae","baf"]

# []の中に * と範囲オブジェクトを書いても同じように配列を作ることができる
[*1..5] -> [1,2,3,4,5]
```

範囲オブジェクトは配列に変換しなくてもそのままeachメソッドを呼び出すことができる

```ruby
sum = 0
(1..4).each { |n| sum += n }

# stepメソッドを使うと値を増やす感覚を指定できる
# 1~10まで2つ飛ばしで繰り返し処理を行う
numbers = []
(1..10).step(2) { |n| numbers << n }
-> [1,3,5,7,9]
```

# いろんな配列

```ruby
# 添え字を2つ使うと、添え字の一と取得する長さを指定することができる
a = [1,2,3,4,5]
a[1, 3]
-> [2, 3, 4]

# value_as メソッドを使うと取得したい要素の添え字を複数指定できる
a.values_at(0, 2,4)
-> [1, 3, 5]

# 最後の要素を取得
a[s.size - 1]

# 添え字に負の値がかけ、その場合最後から何番目として書ける
a[-1] # 最後の文字
a[-2] # 最後から2つ目の文字
a[-2, 2] # 最後から2つ目の文字から2文字

# last関数でも取れる。これの方がわかりやすいじゃん
a.last
-> 5

a.last(2) # [-2, 2] と同意 
-> [4,5]

# 先頭を取るfistもあるよ
a.fist
-> 1

a.fist(2) # [0, 2] と同意

# 複数置換もできる
a = [1,2,3,4,5]
a[1,3] = 100
-> a = [1,100,5]

# << だけではなく、pushでも要素追加ができる。pushだと複数追加が可能
a = []
a.push(1)
a.push(2, 3)
-> a = [1,2,3]

# 指定した値に一致する要素を削除したい場合はdelete
# これだけkeyではなくvalueで判断するのでなんとなく違和感ある
a = [1,2,3,1,2,3]
a.delete(2)
-> a = [1,3,1,3]
```

## 配列の結合
* `concat` : 元の配列を変更する（破壊的メソッド）
* `+` : 新しい配列を作る

```ruby
a = [1]
b = [2,3]

# aは破壊される
a.concat(b)
-> a = [1,2,3]

# aもbも破壊されない
a + b
-> [1,2,3]
a
-> a = [1]
-> b = [2,3]
```

* 基本的には `+` 演算子の方がいい

## 和集合 / 差集合 / 積集合

* `|` : 和集合。あるやつ全部出す。被ってるものはまとめる。
* `-` : 差集合。左の配列から右の配列に含まれるものを除外する
  * これだけ順番が関係あるので一応注意
* `&` : 積集合。両方にあるものだけ出す。
* これらは全て、元の配列を破壊しない
* みたまんま！

```ruby
a = [1,2,3]
b = [3,4,5]

a | b
-> [1,2,3,4,5]
a - b
-> [1,2]
b - a
-> [4,5]
a & b
-> [3,4]
```

効率的に集合を扱える Set クラスもあるのでこちらの方がいい

```ruby
require 'set'

a = Set.new([1, 2, 3])
b = Set.new([2, 3, 4])
# あとは書き方同じ
```

## 多重代入で残りの全要素を配列として受け取る
* 普通は要素が肥えた場合気リス捨てられるが、 `*` がついてると残りを全て配列で受け取ることができる

```ruby
e, *f = 100, 200, 300
-> e = 100
-> f = [200, 300]
```

## 配列の展開
* push で複数入れることはできるが、それで配列を入れると多重配列で入る
* splat展開 `*` を使うことで、展開しつつ代入することができる

```ruby
a = [1]
b = [2, 3]

# 普通に入れると多重配列になる
a.push(b)
-> [1, [2, 3]]

# splat展開をすることで一つの配列になる
a.push(*b)
-> [1, 2, 3]
```

## メソッドの可変長引数
個数に制限のない引数んことを可変長引数という。
* 自分で定義するメソッドで可変長引数を使いたい場合は `*` を使う

```ruby
def method_name( a, b, *c)
  ...
end

# 可変長引数は配列として入ってくる
def greething(*name)
  "#{names.join('と')}、こんにちは！"
end

greething('alice', 'ken')
-> aliceとken、こんにちは！
```

## * で配列同士を非破壊的に連結する
```ruby
a = [1, 2, 3]

# []の中にそのまま配列を置くと、配列の配列になる
[a]
-> [[1, 2, 3]]

[*a]
-> [1, 2, 3]

# これを利用して配列同士の連結に使える
[-1, 0, *a, 4, 5]
-> [-1, 0, 1, 2, 3, 4, 5]
```

* ちょっとこれ気持ち悪いけど、できるってことは覚えておいた方がよさそう。
* なんか違和感あるなぁ…

## %で配列を作る
* 文字列に関しては `%w` `%W` で配列を作ることができる
* カンマ区切りではなく、スペース区切りで書く
* 区切り文字として ! や カッコを使う
* `%W` は、式展開や改行文字などを使える方。 クォーテーションとダブルクォーテーションみたいな感じ。

```ruby
['apple', 'melon', 'orange']

# %w で書くならこんな感じ
%w!apple melon orange!
%w(apple melon orange)
%w(
  apple
  melon
  orange
)

# 値にスペースを含めたいならバックスラッシュでエスケープする
%w(big\ apple small\ lemon orange)

# 式展開や改行文字を使いたい場合は%Wを使う
prefix = 'This is'
%W(#{prefix}\ an\ apple small\nmelon orange)
-> ["This is an apple", "small\nmelon", "orange"]
```

## 文字列を配列に変換する
* `chars` : 文字列中の1文字1文字を配列要素に分解する
* `split` : 引数で渡した区切り文字で文字列を区切る
* 大体ほかの言語にあるやつね

```ruby
'Ruby'.chars
-> ['R', 'u', 'b', 'y']

'Ruby,Java,Perl'.split(',')
-> ['Ruby', 'Java', 'Perl']
```

## 配列に初期値を設定する
* Array.new を使う

```ruby
a = Array.new(0)
-> a = []

# デフォルトではnilが入る
a = Array.new(5)
-> a = [nil, nil, nil, nil, nil]

# 第二引数で指定できる
a = Array.new(5, 0)
[0, 0, 0, 0, 0]

# ブロックを使って初期値を第二引数的な感じで指定できる
# 3で繰り返す配列を作る
a = Array.new(5) { |n| n % 3 + 1 }
-> [1,2,3,1,2]
```

## 配列に初期値を設定する場合の注意点
* 配列の全要素が同じ文字列オブジェクトを参照しているために発生する問題
* Array.new で作った場合は注意が必要ね

```ruby
a = Array.new(5, 'default')
-> a = ["default", "default", "default", "default", "default"]

str = a[0]
str.upcase!
-> str = "DEFAULT"
-> a = ["DEFAULT", "DEFAULT", "DEFAULT", "DEFAULT", "DEFAULT"]
```

* 覚えてないとどっかでやらかしそう
* 回避方法として、ブロックで初期値を渡すようにすればOK

```ruby
a = Array.new(5) { 'default' }
-> a = ["default", "default", "default", "default", "default"]

str = a[0]
str.upcase!
-> str = "DEFAULT"
-> a = ["DEFAULT", "default", "default", "default", "default"]
```

* ブロックを使うと、ブロックが呼ばれるたびに文字列の "default" が新しく作られるからバラバラの文字列を参照するようになるよ
* 処理とか入る可能性があるから、結果的に同じ文字列だったとしても別々のものを見てくれるようになる

## じゃあ全部ブロックでやればいいんじゃないの？
* これには、ミュータブルイミュータブルといった話が出てくる。
* `ミュータブル` : 変更可能な という意味
  * 文字列 などが常にミュータブルである
* `イミュータブル` : 変更不可能な という意味
  * 数値、シンボル、 true/false、 nil などが常にイミュータブルである
* 文字列はさっき upcase! で大文字にしたみたいに変更がOKだ
* 数値などは変更不可能。そのため、例えば初期値が数値であれば変更できず今回のようなケースは発生しないため問題ないという事になる

ミュータブルをイミュータブルにする
* `freeze` メソッドを使うことで変更不可能にすることもできる。
* 再代入禁止の定数みたいなイメージ

## [] や << を使った文字列操作
* 文字列にも同じような感じで使える

```ruby
# 文字列も配列と同じように取れる
a = 'abcde'
a[2]
-> c

a[1, 3]
-> bcd

a[-1]
-> e

# 置換
a[0] = 'X'
-> "Xbcde"

a = 'abcde'
a[1,3] = 'Y'
-> "aYe"

a = 'abcde'
a << 'XYZ'
-> "abcdeXYZ"
```

# ブロックについてもっと詳しく
## 添え字付きの折り返し処理
* 通常のeachだと何ループ目かのindexが返ってこないが `each_with_index` を使うと可能
* eachでindexが欲しい場合はこれが最適

```ruby
fruits = ['apple', 'melon', 'orange']
fruits.each_with_index { |fruits, i| p "#{i}: #{fruits}"}
-> "0: apple"
-> "1: melon"
-> "2: orange"
```

* map等でも添え字が欲しい場合、 `with_index` メソッドを付ける
* ほぼ書き方同じだし、なんで each だけ専用メソッドあるのかは不明。。。
* なんなら、 each も `each.with_index` って書いて動いた

```ruby
fruits = ['apple', 'melon', 'orange']
fruits.map.with_index { |fruits, i| p "#{i}: #{fruits}"}
-> "0: apple"
-> "1: melon"
-> "2: orange"

# delete_if とかにもくっつけることができる
# 名前に a を含み、奇数の時削除みたいな感じ
fruits = ['apple', 'orange', 'melon']
fruits.delete_if.with_index { |fruits, i| fruits.include?('a') && i.odd?  }
-> ["apple", "melon"]
```

* with_index は、 Enumerator クラスのインスタンスメソッド
* each や map などは Enumerator クラスを返すので、これが呼び出せる

```ruby
p fruits.each
-> <Enumerator: ["apple", "melon"]:each>
```

* 添え字を 0 以外から開始させるには、 with_index の引数に設定する
* each_with_index は引数が渡せないから、使いたい場合は with_index を使う必要がある
  * いらなくないかそのメソッド・・・

```ruby
fruits = ['apple', 'melon', 'orange']
fruits.map.with_index(1) { |fruits, i| p "#{i}: #{fruits}"}
-> "1: apple"
-> "2: melon"
-> "3: orange"
```

