1章 ~ 2章は本当に基本的な事のためメモ割愛
大体の構文はperlと同じだね

# 3章 テストを自動化する
3章からいきなりテスト自動化の話

#### Minitest
テスティングフレームワークの一つ。
rubyをインストールされると自動的にインストールされ、かつ学習コストが比較的低くRailsのデフォルトのフレームワークでもあるためRailsをやる場合にも生かしやすい。
Ruby 2.2以上であればMinitestのバージョンも5系がインストールされるがそれより前だと書き方が少し違う。本書では 5系の描き方のためバージョンが違う場合は合わせる。

```shell
 /m/c/U/m/w/ruby_test  ruby -v
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux-gnu]
```

* 問題なし

テストコードの雛形

```ruby
# sample_test.rb

require 'minitest/autorun'

class SampleTest < Minitest::Test
  def test_sample
    assert_equal 'RUBY', 'ruby'.upcase
  end
end
```

* クラス名はキャメルケース。先頭も大文字！
* ファイル名はスネークケース。
* `< Minitest::Test` の部分は、SampleTestクラスが Minitest::Testクラスを継承することを表している
* minitestは `test_` で始まるメソッドを探してそれを実行するためこの命名規則は必須。
* メソッドは何個書いてもOK。このへんはScalaとかと同じかな。 test_ ってついてるやつは全部実行してくれるよ。
* クラス名は `SampleTest` のようにTestが後ろについたり、Minitestはtest_って頭にTestが付くから `TestSample` に統一したりとか色々宗教がある。チームメンバーでルールを決めよう！

assert_equal
* これがテスト検証メソッド。 左と右が正しければOKとする。名前的にもわかりやすいね
* 他にも色々あるので一部抜粋

```ruby
# aとbが等しければOK
assert_equal a, b

# aが真であればOK
assert a

# bが偽であればOK
refute a
```

他にも色々あるけど大体このあたりしか使わないので一旦ここだけ覚えておけばOK

#### テストコードの実行方法
普通にrubyで実行するだけ。書き方さえちゃんとできていればOKだよ

```ruby
 /m/c/U/m/w/ruby_test  ruby sample_test.rb
Run options: --seed 47782

# Running:

.

Finished in 0.001058s, 945.0903 runs/s, 945.0903 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

* Running の下のドット数がテスト数。今回1個だから1個
* スピードもめっちゃ速い。
  * 0.001058s : テスト実行にかかった秒数
  * 945.0903 runs/s : 1秒感に実行できるであろうテストメソッドの数
    * 今1秒に945できるって事！？すげえ
    * 簡単なテストだからだと思うけど
  * 945.0903 assertions/s. : 1秒感に実行できるであろう検証メソッドの件数
    * ちょっとここの違いはよくわからなかったのでもっとテスト増やしてみて確認してみる
* 1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
  * みたまんま。OKという欄はないので、エラーとフェイルが0であればOKと判断する。
  * skips は、スキップメソッドというのを仕込んでいない限り入らない。テストコード実装中とか、障害対応でテストを強制スキップさせるなどの用途で使う

エラーの時はこんな感じ

```ruby
 /m/c/U/m/w/ruby_test  ruby sample_test.rb
Run options: --seed 43598

# Running:

F

Finished in 0.000574s, 1742.1603 runs/s, 1742.1603 assertions/s.

  1) Failure:
SampleTest#test_sample [sample_test.rb:5]:
Expected: "RUBY"
  Actual: "Ruby"

1 runs, 1 assertions, 1 failures, 0 errors, 0 skips
```

* そもそもドットででてこない。こけたらFのFalseで返ってくる。
* `SampleTest#test_sample [sample_test.rb:5]:` : SampleTestクラスのtest_sampleで、5行目のやつでこけた
* `Expected: "RUBY" Actual: "Ruby"` 期待結果は RUBY だけど Ruby で返ってきたぞって怒ってる
* めちゃめちゃわかりやすい
* テストが失敗すると、そのテストメソッドはそれ以上実行されない。
* テストの結果でこけたら F だが、テストコードの中身の描き方自体でエラーになった場合は E になる。

#### FizzBuzzのテストコードを書いてみる

```ruby
def fizz_buzz(n)
  if n % 15 == 0
    'FizzBuzz'
  elsif n % 3 == 0
    'Fizz'
  elsif n % 5 == 0
    'Buzz'
  else
    n.to_s
  end
end

require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  def test_fizz_buzz
    assert_equal '1', fizz_buzz(1)
    assert_equal '2', fizz_buzz(2)
    assert_equal 'Fizz', fizz_buzz(3)
  end
end
```

* 同じコード内に書いてあっても通る、すごいわかりやすい

#### テストコードとプログラム本体を分離する
一緒に書く必要があるのかと思ったけど別に書いてOKらしい。

```ruby
./sample.rb #プログラム本体
test/fizz_buzz_test.rb #テストコード

require 'minitest/autorun'
require './sample.rb'

class FizzBuzzTest < Minitest::Test
  def test_fizz_buzz
    assert_equal '1', fizz_buzz(1)
    assert_equal '2', fizz_buzz(2)
    assert_equal 'Fizz', fizz_buzz(3)
    assert_equal '4', fizz_buzz(4)
    assert_equal 'Buzz', fizz_buzz(5)
    assert_equal 'Fizz', fizz_buzz(6)
    assert_equal 'FizzBuzz', fizz_buzz(15)
  end
end
```

requireは実行箇所からの相対パスになる。
