# 10章 yieldとProcを理解する
# yield
* メソッドにブロックを渡すのは、自作メソッドでももちろん可能
* ブロックをメソッドで受け取るには `yield` を使う
  * Scalaと全然使い方違うね
* 2個かけば、2回受け取るよ

```ruby
def greeting
  p 'mike'
  # ここでブロック引数受け取る
  yield
  p 'cat'
end

greeting do
  p 'neko'
end
"mike"
"neko"
"cat" 
```

* yield を書くとブロック引数が無いときにエラーになってしまう
* `block_given?` でブロック引数付きで呼び出されているかわかるので、if分岐ができる

```ruby
if block_given?
  yield
end
```

* yield でブロックに引数を逆に渡すこともできる

```ruby
def greeting2
  yield 'みけにゃ～'
end

# mike に 'みけにゃ～' が入ってくる
greeting2 do |mike|
  p mike * 2
end
-> "みけにゃ～みけにゃ～"

# 引数が多いと、nilが入る
greeting2 do |mike, neko|
  p mike * 2 + neko
end
-> "みけにゃ～みけにゃ～nil"

# 渡す数が多いと、無視される
def greeting2
  yield 'みけにゃ～', 123, 456
end
```

* `&` を付けることで、引数として明示的に受け取ることができる
* `call` で呼び出すことができる
* `引数.call` で `yield` と同様と思ってよさそう

```ruby
def メソッド(&引数)
  引数.call
end

# さっきのかくとこうなる
def greeting3(&mike)
  mike.call('みけにゃ～')
end

greeting3 do |mike|
  p mike * 2
end
```

* メリットとして、他メソッドにブロック引数を渡すことができるようになる
  * `arity` メソッドでブロック引数の個数を確認することが可能。こうしたメソッドも呼べる

```ruby
def greeting(&block)
  greething_common('mike', &block)
end

# 受け取り側も &blockで書く必要があるぞ！
def greething_common(text, &block)
  # arity で、ブロック引数個数を取得できる。1つなら、1
  if block.arity === 1
    ...
  end
end
```

## Proc
* ブロックをオブジェクト化するためのクラス
* String -> 文字列、 Array -> 配列 みたいな感じで、 Proc -> ブロック
* `Proc.new` にブロックを渡すとインスタンス化できる
* `call` しないと動かないよ

```ruby
hello_proc = Proc.new do
  p 'Hello!'
end

# ただ呼ぶだけじゃ動かないよ
hello_proc

# callする必要があるよ
hello_proc.call
-> 'Hello!'

# 呼び出し時に足し算するProc
add_proc = Proc.new { |a, b| a + b }
p add_proc.call(10, 20)
```

* `proc` というメソッドが Kernelモジュールにあるのでこれでも同じことできるよ

```ruby
add_proc = proc { |a, b| a + b }
```

* Procオブジェクトはオブジェクトとして扱うことができるようになる。つまり、変数として渡したりすることができる
* これがさっきの `&引数` と同じだよ。あれはProcオブジェクトだったのだ！
  * arity が呼べるのも、Procメソッドの組み込みメソッドだからだよ
* Procオブジェクトを普通の引数として渡すこともできるよ
  * ブロック引数としても渡せるよ

```ruby
def greeting(hoge)
  hoge.call('hello')
end

repeat_proc = Proc.new{ |text| text * 2 }
greeting(repeat_proc)

# こうとも書ける。好み？
def greeting(&hoge)
  hoge.call('hello')
end

repeat_proc = Proc.new{ |text| text * 2 }
greeting(&repeat_proc)
```

## ラムダでProcオブジェクトを作る
* `Proc.new` と `proc` 以外にも作る方法がある
* `->` と `lambda` で、両方ともラムダと呼ぶ
  * `->(a, b) { a + b }`
  * `lambda { |a, b| a + b }`
* `->` はラムダリテラル、またはアロー関数と呼ばれる

```ruby
# ()は省略可能
-> a, b { a + b }

# 引数なかったらもっとシンプルに！
-> { 'Hello' }

# do..end でもOK
-> (a, b) do
  a + b
end

# 初期値持たせることもできるよ
->(a = 0, b = 0) { a + b }
```

### ラムダの違い
* 呼び出し方は同じだが、 `引数のチェックが厳密` という特徴を持つ
* 引数の個数が違ったりすると、エラーを吐く
  * 普通のブロックだと切り捨てたりnilが入ったり勝手にするよ

### lambda? でラムダなのかただのProcなのか見分ける
* どっちもProcメソッドだが振る舞いが違う。
* `lambda?` で、ラムダならtrueが返ってくるのでこれを使うといい

# 例題メモ
## メソッドチェーン
* こんな感じのメソッドが連結してるのはメソッドチェーンと呼ぶ
* つながりがわかりやすいが、横に長くなりやすいので改行するのがいい
* あまりに複雑だと、デバッグや確認もしづらくなるので適度に説明変数とかに入れるのがよさそう

```ruby
# split -> map -> join のメソッドチェーン
words.split(' ').map { |word| word.upcase + '!' * level }.join(' ')

# こう書くと横に長くならないよ
words
  .split(' ')
  .map { |word| word.upcase + '!' * level }
  .join(' ')
```

# Procについてもっと詳しく
## Procオブジェクトを実行する様々な方法
* `.call` 何度も使ってる通りに呼べる
* `.yield` これも同じように呼べる
* `.()` これでも呼べる！？
* `[]` でもOK。これはどっとなしの点に注意
* ` === []` でも呼べる！これはcase文で呼べるように組み込まれているため。まぁ、これで呼ぶのはわかり面過ぎるからやめた方がよさそう。

## &とto_procメソッド
* `&` を付けることでProcだと認識してくれて渡せるようになる。
* ただ、厳密には右辺に対して `to_proc` メソッドを呼び出している。その返り値のProcオブジェクトを渡している感じだ
* もとからProcのものに to_proc してもなにも効果はないが、動くので問題ない

```ruby
# mapにも&でProcとして渡すと動いてくれるよ
reverse_proc = Proc.new { |s| s.reverse }
p ['Ruby', 'Java'].map(&reverse_proc)
```

* シンボルも to_proc メソッドを呼ぶことができる

```ruby
split_proc = :split.to_proc

# 第一引数だけだと空白で区切る
p split_proc.call('a-b-c d')
-> ["a-b-c", "d"]
# 第二引数があるとそれで区切る
p split_proc.call('a-b-c d', '-')
-> ["a", "b", "c d"]

# これと結果同じだから同じことやってるっぽい
split_proc2 = Proc.new { |s, p| s.split(p) }
p split_proc2.call('a-b-c d')
p split_proc2.call('a-b-c d', '-')
```

## &:メソッド を改めて考える
* これまでを踏まえると、 `&:upcase` などがどうやって動いているのかわかる

```ruby
# 以下は同じだよね
['mike', 'neko'].map { |s| s.upcase }
['mike', 'neko'].map(&:upcase)
```

これを例にすると

1. &:upcase は、シンボルの :upcase に対して to_proc メソッドを呼ぶ
2. :upcase がProcになる。 mapメソッドにブロックとして渡される。
3. mapメソッドは配列の各要素をレシーバとし、ブロックに渡す。このパターンだと、 `各要素.upcase` を実行していることになる
4. mapメソッドはProcオブジェクトの戻り値を新しい配列に詰め込む
5. 繰り返され、大文字になった配列が出来上がる

## Procオブジェクトとクロージャ
* メソッド引数やローカル変数は通常メソッドが終わると参照できなくなる
* 例外として、Procオブジェクト内で引数やローカル変数を参照すると、メソッドの実行が完了してもProcオブジェクトはアクセスすることが可能
* メソッドが生成されたときのコンテキスト（変数情報）を保持しているメソッドの事を、クロージャという。
* ブロックやProcオブジェクトはクロージャであるという事を覚えておこう

## 微妙な Proc.new とラムダの違い
* 厳密なチェックをするのがメインだが、 `return` `break` を使った時も微妙な違いがある
* `proc` 
  * return を使うとメソッドを抜ける
  * break を使うと例外が発生する `break from proc-closure`
* `lambda`
  * return を使ってもラムダ内の処理から抜けるだけ
  * ループ処理は中断されず、最後まで実行される

```ruby
def proc_return
# n * 10 を実行してreturnしちゃう
  f = Proc.new { |n| return n * 10 }
  ret = [1, 2, 3].map(&f)
  "ret: #{ret}"
end

def lambda_return
# ラムダ内の処理から抜けるだけなので、 n * 10 を3回やってくれる
  f = ->(n) { return n * 10 }
  ret = [1, 2, 3].map(&f)
  "ret: #{ret}"
end

p proc_return
-> 10
p lambda_return
-> "ret: [10, 20, 30]"

# break
def proc_return
  f = Proc.new { |n| break n * 10 }
  ret = [1, 2, 3].map(&f)
  "ret: #{ret}"
end

def lambda_return
  f = ->(n) { break n * 10 }
  ret = [1, 2, 3].map(&f)
  "ret: #{ret}"
end

p proc_return
-> break from proc-closure
p lambda_return
-> "ret: [10, 20, 30]"
```

* これ以外にも色々違いがあるので随時調べてみよう
* とりあえず、Proc/ラムダ内で return や break を使うのは辞めようね