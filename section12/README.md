# 12章 その他のトピック
* メインでは触れなかった、覚えておいた方がいいものを色々

## 日付や時刻の扱い
* 日付と時刻を扱うクラス
  * `Time` : 組み込みライブラリ
  * `DateTime` : dateをrequireする必要あり
* 日付を扱うクラス
  * `Date` : dateをrequireする必要あり

```ruby
p Time.new(2017, 1, 31, 23, 30, 59)
-> 2017-01-31 23:30:59 +0900

require 'date'

p Date.new(2017, 1, 31)
-> #<Date: 2017-01-31 ((2457785j,0s,0n),+0s,2299161j)>
p DateTime.new(2017, 1, 31, 23, 30, 59)
-> #<DateTime: 2017-01-31T23:30:59+00:00 ((2457785j,84659s,0n),+0s,2299161j)>
```

* TimeとDateTimeは役割がほぼ同じ。
* Time は、2038年問題を持っていたが解決された。
* DateTimeはTimeより遅いという問題を持っていたが、Cで実装されパフォーマンスが良くなった。
* 大した違いはないので、require無しで使える `Timeが主流`
* `Time` はサマータイムやうるう秒を扱うことができる。
* また、 Timeは `+0900` とJSTで扱っている。 DateTime は `+0s` とUTCで扱っている点に注目。

## ファイルやディレクトリの扱い
* 組み込みライブラリ
  * `File` : ファイル探索。openなど可能
  * `Dir` : ディレクトリ探索。
  * 共通して、 `.exists?()` で存在するか問い合わせることができる
  * require無しで実行可能

```ruby
File.open('../section3/sample.rb', 'r') do |f|
  p f.readlines.count
end

File.open('./test.txt', 'w') do |f|
  f.puts 'Hello, world!'
end
```

* `FileUtils` はファイル操作を集めたモジュール。コピーや削除などを便利に実行できる

```ruby
# mv ./test.txt ./hello_world.txt
require 'fileutils'
FileUtils.mv('./test.txt', './hello_world.txt')
```

* `Pathname` はパス名をオブジェクト指向として扱うことができるクラス
* 自分自身がファイルかどうかをい返すメソッドや、新しいパス文字列を組み立てるメソッドなどが定義

```ruby
require 'pathname'
lib = Pathname.new('./README.md')
p lib.file?
-> true
p lib.directory?
-> false
```

## requireについて
* requireの単位は、クラスではなくライブラリ。
* require 'date' をやると、DateだけではなくDateTimeも取れるよね。
* 新しいコマンドを追加するだけのrequireがあったり、様々

## 特定の形式のファイルを読み書きする
### CSV
* `CSV` クラスを使うことで可能。 requireが必要
* タブ区切りの TSV も扱うことができるよ！

```ruby
require 'csv'

# CSVの出力
CSV.open('path', 'w') do |csv|
  # ヘッダ行を出力
  csv << ['Name', 'Email', 'Age']
  # 明細行を出力する
  csv << ['Mike', 'hoge@com', '24']
end

# TSVを読み込む
CSV.foreach('path', col_sep: "\t") do |row|
  puts "1: #{row[0]}, 2: #{row[1]}, 3: #{row[2]}
end
```

### JSON
* `require 'json'` で、配列やハッシュに `.to_jsoin` してJSONにできるようになる

```ruby
require 'json'
user = {name:'mike', email: 'hoge@com'}
p user.to_json
-> "{\"name\":\"mike\",\"email\":\"hoge@com\"}"

# シンボルでもできたっぽいけど、 hoge@com みたいなのやったらエラーになった
user2 = {name: :mike}
p user2.to_json
-> "{\"name\":\"mike\"}"

# 逆もできるよ
p JSON.parse(user.to_json)
-> {"name"=>"mike", "email"=>"hoge@com"}
```

### YAML
* `require 'yaml'` で扱えるようになる

```ruby
require 'yaml'
yaml = <<TEXT
mike:
  name: 'Mike'
  email: 'alice@example.com'
  age: 20
TEXT

# ハッシュにしてrubyで扱えるようにする
users = YAML.load(yaml)
p users
-> {"mike"=>{"name"=>"Mike", "email"=>"alice@example.com", "age"=>20}}

# 要素追加
users['mike']['sex'] = :man
p users
-> {"mike"=>{"name"=>"Mike", "email"=>"alice@example.com", "age"=>20, "sex"=>:man}}

# YAMLに変換
p YAML.dump(users)
-> "---\nmike:\n  name: Mike\n  email: alice@example.com\n  age: 20\n  sex: :man\n"
```

## 環境変数や起動時引数の取得
* `ENV` に環境変数が入る
* `ARGV` 起動時引数を取得
* だいたいScalaといっしょ

```ruby
# fishシェル使ってるからset使ってるけど普通のbashならexport
$ set NAME = 'mike'
$ ruby sample.rb mike 20

p ENV['MY_NAME']
p ARGV[0]
p ARGV[1]
```

* ENVやARGVはObjectクラスに最初から組み込まれている定数。こういうのを組み込み定数と呼ぶ。
* 組み込み定数に再代入するのはwarningsが出るし、やるべきじゃないからやめようね！

## eval, バッククォートリテラル, send
* `eval` : 受け取った文字をコードとして実行する

```ruby
code = '[1, 2, 3].map{ |n| n * 10 }'
```

* バッククォートリテラルは、バッククォートで囲まれた部分をOSコマンドとして実行する
* Scalaと同じ
* `%x{}` でもOK

```ruby
puts `cat ../section3/sample.rb`
```

* `send` : レシーバに対して指定した文字列のメソッドを実行する

```ruby
# 'a'.upcase と同じ
'a'.send('upcase')
```

* これらは、動的に文字列を切り替えて処理を分けたい場合に使える。
* ただ、任意の文字列で実行できてしまうので、もしそれを受け取って流すような仕組みにしてしまうと悪意のあるユーザや間違って入力したときにとんでもないメソッドが実行されて大障害になる可能性もある。
* 乱用は注意。やるなら、安全面をきにしよう。

## Rake
* make コマンドのRuby版
* ビルドツールとして開発されたが、まとまった処理を簡単に実行するためのツールとして広く使われている。
* Rubyプログラムを内部DSLとして使用できる。
* RakeはRakefileという名前のファイルにタスクを定義する
  * Makefileと一文字違いだし完全に参考にしてるね

```ruby
# Rakefile
task :hello_world do
  puts 'Hello, world!'
end

$ rake hello_world
Hello, world!
```

* desc メソッドで説明追加できる。
* `rake -T` でタスクの一覧が説明付きで表示される
* タスクが増えてきたら ネームスペース を使ってタスクを管理できる
  * 呼び出しは、`:` で区切る

```ruby
desc "テスト用のタスクです"
namespace :my_tasks do
  task :hello_world do
    puts 'Hello, world!'
  end
end

rake -T
-> rake my_tasks:hello_world  # テスト用のタスクです
rake my_tasks:hello_world
```

* よく使われるタスクはあらかじめ用意されている
* 複数のテストコードを一括して実行する `Rake:TestTask` など

```ruby
require 'rake/testtask'

# タスクの名前がtestになる
Rake::TestTask.new do |t|
  t.pattern = 'section*/test/*_test.rb'
end

# testタスクをデフォルトのタスクに設定する
# デフォルトに設定することで、 rake とうつだけでテストが走るようになる
task default: :test
```

## RubyとDSLの相性の良さ
* `DSL` : ドメイン固有言語と訳され、人間に理解しやすいテキストファイルの記述ルールの事。
* カッコを省略できるなどの特性を上手く使うことで、まるでただの英文のようにプログラミングを書けるためDSLと相性がいい。

## gemとBundler
* gem
  * RubyGems.org というサイトにアップロードされている
  * `gem install ライブラリ名`
  * rbenvなどでRubyのバージョンを切り替えている場合は、バージョンごとにインストールが必要という点に注意
    * npmのグローバルインストールみたいなのできないのかな？
* Blender
  * gemのあるライブラリを動かすのに、このライブラリの〇〇バージョンが必要だ！というものを一括管理してくれるもの。
  * 1つのマシンに同じgemの複数バージョンがある場合、プログラム実行時に使用するgemのバージョンを切り替えてくれる <-すげ-

```ruby
$ sudo gem install bundler
$ bundle init
Writing new Gemfile to /***/ruby_test/Gemfile
```

* `Gemfile` が作られる。ここに、さっきの fakerを追加してみる
* `Gemfile.lock` というのも同時に作られる。 yarn.lock みたいなやつ。
  * じぶんでいじっちゃだめだよ

```ruby
gem 'faker'

$ bundle install
Fetching gem metadata from https://rubygems.org/....
Resolving dependencies...
Using bundler 2.1.4
Using concurrent-ruby 1.1.6
Following files may not be writable, so sudo is needed:
  /usr/local/bin
  /var/lib/gems/2.5.0
  /var/lib/gems/2.5.0/build_info
  /var/lib/gems/2.5.0/cache
  /var/lib/gems/2.5.0/doc
  /var/lib/gems/2.5.0/extensions
  /var/lib/gems/2.5.0/gems
  /var/lib/gems/2.5.0/specifications
Using i18n 1.8.5
Using faker 2.13.0
Bundle complete! 1 Gemfile dependency, 4 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

* `i18n` という依存関係モジュールをインストールしてくれているのが確認できる
* Bundlerでgemをインストールした場合は、通常のコマンドの手前に `bundle exec` を付けて実行する

### Gemfileのバージョンの指定方法
* `gem 'faker'` : bundlerにお任せする
* `gem 'faker', '1.7.2'` : 指定したバージョンをインストール
* `gem 'faker', '>= 1.7.2'` : 指定したバージョン以上
* `gem 'faker', '~> 1.7.2'` : 指定したバージョン以上かつ、 1.8 未満。マイナーバージョンはあげたくない場合に使用
* `gem 'faker', '~> 1.7'` : 指定したバージョン以上かつ、 2.0 未満。メジャーバージョンはあげたくない場合に使用