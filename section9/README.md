# 9章 例外処理
* 考え方は他言語と同じ。あと、rubyはエラーが発生したらその瞬間処理を停止するので以降の処理は実行しない。

```ruby
begin
  # 例外が起きる可能性のある処理
rescue
  # 例外時の処理
end

p 'start'
module Greeter
  def hello
    'hello'
  end
end

begin
  # モジュールはインスタンス化できないのでエラーになる
  greeter = Greeter.new
rescue
  p '例外が発生したが、このまま実行する'
end

p 'End'
"start"
"例外が発生したが、このまま実行する"
"End"
```

* `rescue => 変数` で、エラーをキャッチできる

```ruby
begin
  1 / 0
rescue => e
  p "エラークラス#{e.class}"
  p "エラーメッセージ#{e.message}"
  p "バックトレース#{e.backtrace}"
  p e
end

"エラークラスZeroDivisionError"
"エラーメッセージdivided by 0"
"バックトレース[\"sample.rb:18:in `/'\", \"sample.rb:18:in `<main>'\"]"
#<ZeroDivisionError: divided by 0>
```

* 色々なエラーがあるが、指定することで対象のエラーの時だけ例外処理をすることができる
* APIのエラーの時とかに使えそう！
* `rescue 対象のエラー => 変数`

```ruby
begin
  1 / 0
rescue ZeroDivisionError => e
# ZeroDivisionError の時だけ入る
  puts e.backtrace
end
```

* rescueは複数かける

```ruby
begin
  1 / 0
rescue ZeroDivisionError => e
  puts e.backtrace
rescue NoMethodError => 3
  puts e.backtrace
end
```

* 複数条件に書く事もできる

```ruby
begin
  1 / 0
rescue ZeroDivisionError, NoMethodError => e
  puts e.backtrace
end
```

## エラーの継承関係
* `Exception` という親クラスを全て継承している
  * その下に、 `StandartError` という通常プログラムで主に発生する親クラスがある
    * その下に、色々なエラーがある
  * 同じ階層に特殊なエラーを扱うクラスもあるが、今回取り扱わない
    * `NoMemoryErrorやSystemExit` など。他要因などがこちらに入る。
* rescueに何もクラスを指定しなかった場合に補足されるのは、StandardErrorになる。つまり、特殊なエラーは拾ってくれない。
  * 拾いたいならば、全てを含めている `Exception` をrescueの条件に加えればOK。
* ただ、通常はStandardErrorに留めておくべき。他言語の Exception = RubyのStandardError という認識の方が良い。

## 継承関係とrescueの書き方
* rescueは上から順番に評価されていくので、継承関係を理解していないとえいえんにじっこうされないrescueを作ってしまう可能性もある
* 一番上にException を書いたりしたら、その下のrescueは絶対入らないという事を覚えておく

## 例外発生時もう一度処理をやり直すretry
* ネットワークエラーのような一時的なエラーであれば、再実行でなんとかなる可能性もある
* rescue の中に `retry` と書くだけでOKだが、例外が直らない限り無限ループする可能性があるのでカウンターなどをセットするのがいい
* retry をすると、 begin の処理を最初からやり直す

```ruby
retry_count = 0
begin
  p 'start'
  1 / 0
rescue
  retry_count += 1
  if retry_count <= 3
    p 'retry now'
    retry
  end
end
```

## 意図的に例外を発生させる
* `raise` で例外を発生させることができる。 Scalaでいう new Exception みたいなやつかな。
* デフォルトで `RuntimeError` になる。
* `raise "エラーメッセージ"` と引数に渡した文字をエラーメッセージとして出してくれる
* `raise エラークラス, "エラーメッセージ"` とすることでRuntimeErrorから変えることができる
  * `raise ArgumentError.new("エラーメッセージ")` でもいいよ

# 例外処理の考え方
## むやみにrescueを使わない
* エラーが発生しているのに安易にrescueを多用して無理やりプログラムを動かしていると思わぬ不具合が生まれる可能性がある。
* 例外が発生したら、即座に異常終了させエラーページに飛ばす、またはフレームワークの共通処理に全部丸投げしようと考えるほうが安全

## rescueするなら情報を残す
* たとえば、100人にメールを送って一人だけおかしい形式がいてエラーになったとする。
* それを原因特定するために、必要な情報を残すのはrescueが適切だ。
* 最低でも、 以下3つはエラーログに残すべき。
  * `発生した例外のクラス名 : e.class`
  * `エラーメッセージ : e.message`
  * `バックトレース : e.backtrace` 

## 例外処理の対象範囲と対照クラスを極力絞り込む
* たとえば、日付を作る処理があって、日付を色々セットする処理は例外が起きない
* それを Date メソッドに渡す時に例外が起きる可能性がある
* であれば、Dateメソッドに渡す時のみ例外処理にくくるべきだ。そうすることで、エラーの範囲を絞り込めつつ rescue の条件も絞り込むことができる

## 条件分岐でなんとかできないか考える
* さっきの例の Date だと、 `Date.valid_date?` という組み込み関数で日付として妥当かどうかを真偽値で返してくれる
* これを if で挟むことで例外処理をしなくても、elseで例外処理ができる。
* むやみにエラーを許容するよりこちらの方が良い。可読性もよく、パフォーマンスもよい。

## 予期しない条件は、さっさと異常終了させる
* case文などの場合、ある程度分岐したい条件が決まっているはず。それにマッチしないものが来たとして、どうするか？
* 適当にnilで返したとしたら、その受け取り先のメソッドでエラーがでるかもしれない。そうしたら、原因特定が困難になる。「なぜnilが返ってきたのか？」と前の処理を全部確認したり。
* nilのままDBに登録されたりしたら、その利用先でもっと不具合がでるかもしれない。影響範囲がどんどん広がっていく。
* それであれば、最初からcase文で予期しない文字が来たときはさっさと異常終了させる方がいい不具合であるといえる。

# 例題のメモ
## getsメソッド
* ユーザーの入力を受け付ける、Kernelメソッド
* デフォルトだとエンターキーの \n も入るため、chompするのがいい

```ruby
input = gets.chomp
```

# 例外処理についてもっと詳しく
## ensure
* 例外が発生してもしなくても実行したい処理を書く

```ruby
begin
rescue
ensure
  # 例外の有無にかかわらず実行処理
end

# 異常終了してもいいが、その前に ensure をしてほしいときはrescure句を抜く
begin
ensure
end
```

## else
* 例外が発生しなかった時に、実行される
* つまり、beginの中で例外が起こる可能性がある処理の後になる
* そのままbeginに続けて書いてしまってもいいためあまり使われない
* rescue と ensure の間に書く

```ruby
begin
rescue
else
ensure
end
```

## 例外処理の戻り値
* 正常に終了した場合、beginの最後の行が返り値
* 異常終了した場合、rescueの最後の行が返り値
* メソッドの戻り値として使われるパターンが多いので覚えておこう

## begin/endを省略するrescue修飾子
* `例外が起きそうな処理 rescue 例外したときの戻り値` で書ける
* perlの `or die` みたいな感じ！
* デメリットとして、例外クラスの指定ができずに `StandardError` で固定される

```ruby
# 例外が発生しない
1 / 1 rescue 0
1

# 例外が発生する
1 / 0 rescue 0
-> 0
```

## $!と$@に格納される例外情報
* `$!` に、最後に発生した例外が格納される
  * `$!.class $!.message` で `e.class e.message` と同じ
* `$@` バックトレース情報はこっち。
  * `$@` で `e.backtrace` と同じことができる
* 可読性は最悪だから使わない方がいいよ

## begin/endを省略
* メソッド全体を begin ~ end でくくる場合、省略して rescue を書いても動作する

```ruby
def fizz_buzz(n)
  begin
  rescue
  end
end

# こう書ける
def fizz_buzz(n)
  rescue
end
```

## 二重例外に注意しよう
* rescue句で例外を発生させたりすると、元の例外が握りつぶされ原因が迷子になる
* Exceptionクラスのcauseメソッドでもともと発生していた例外情報を取得することはできるが、そもそもこの状況が好ましくないため気を付ける

## rescureした例外を再度発生させる
* rescure節のなかで、 `raise` を使うことで同じエラーを再発させることができる
* 一度ログに残してから、メールで送ってから異常終了させるなどのパターンで有効

```ruby
rescue => 3
  p "[Log]..."
  raise
end
```

## 独自の例外クラスを作る
* StandardErrorを継承して作ればOK。Exceptionは直接継承しないように！

```ruby
class HogeError < StandardError
  attr_reader :country

  def initialize(message, country)
    @country = country
    super("#{message}, #{country}")
  end
end

raise HogeError.new("無効な国名です。", "mike_japan")

# こう拾える
rescue HogeError => e
  p e.message
  p e.country
end
```