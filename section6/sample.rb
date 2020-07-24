text = <<TEXT
I love Ruby
Python is a great language.
Java and JavaScript are different.
TEXT

p text.scan(/[A-Z][A-Za-z]+/)

# Regexpクラスになるよ
regex = /\d{3}-\d{4}/
p regex.class

# マッチした場合は文字列の開始位置が返る。つまり、真である
p '123-4567' =~ regex

# マッチしない場合はnil。つまり、偽である
p 'hello' =~ regex

p '123-4567' !~ regex
p 'hello' !~ regex

# キャプチャ
text = '私の誕生日は1960年10月1日です。'
m = /(\d+)年(\d+)月(\d+)日/.match(text)
p m
p m[0]
p m[1]
p m[2]
p m[3]
p m[2, 2]
p m[-1]
p m[1..3]

text = '私の誕生日は1960年10月1日です。'
if m = /(\d+)年(\d+)月(\d+)日/.match(text)
  # マッチした場合の処理、mをそのまま使える
else
  # マッチしない処理
end

m = /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/.match(text)
p m
p m[:year]
p m[:month]
p m[:day]
p m['year']
p m[1]

text = '私の誕生日は1960年10月1日です。'
if /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/ =~ text
  p "#{year} : #{month} : #{day}"
end

# if text =~ /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/

# scan
p '123 456 789'.scan(/\d+/)

# 正規表現に()があると、キャプチャされた部分が配列の配列になって帰ってくる
p '1977年7月17日 2016年12月31日'.scan(/(\d+)年(\d+)月(\d+)日/)

# グループ化はしたいが、キャプチャはせず文字列全体を取得したい場合に使う?:
p '1977年7月17日 2016年12月31日'.scan(/(?:\d+)年(?:\d+)月(?:\d+)日/)

# 正直これでもいい
p '1977年7月17日 2016年12月31日'.scan(/\d+年\d+月\d+日/)


text = '郵便番号は123-4567です'
p text[/\d{3}-\d{4}/]

# 複数マッチする場合最初の奴が返ってくる
text = '郵便番号は123-4567 456-7890です'
p text[/\d{3}-\d{4}/]

text = '私の誕生日は1977年7月17日です'
p text[/(\d+)年(\d+)月(\d+)日/]
p text[/(\d+)年(\d+)月(\d+)日/, 3]

p text.slice(/(\d+)年(\d+)月(\d+)日/)
p text.slice!(/(\d+)年(\d+)月(\d+)日/)
p text

text = "123,456-7890"

p text.split(',')
p text.split(/,|-/)

text = "123,456-7890"

p text.gsub(',', ':')
p text.gsub(/,|-/, ':')

text = '私の誕生日は1977年7月17日です'

p text.gsub(/(\d+)年(\d+)月(\d+)日/, '\1-\2-\3')
p text.gsub(
  /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/,
  '\k<year>-\k<month>-\k<day>'
)


text = "123,456-7890"
hash = { ',' => ':', '-' => '/'}
text = <<TEXT
I love Ruby
Python is a great language.
Java and JavaScript are different.
TEXT

p text.scan(/[A-Z][A-Za-z]+/)

# Regexpクラスになるよ
regex = /\d{3}-\d{4}/
p regex.class

# マッチした場合は文字列の開始位置が返る。つまり、真である
p '123-4567' =~ regex

# マッチしない場合はnil。つまり、偽である
p 'hello' =~ regex

p '123-4567' !~ regex
p 'hello' !~ regex

# キャプチャ
text = '私の誕生日は1960年10月1日です。'
m = /(\d+)年(\d+)月(\d+)日/.match(text)
p m
p m[0]
p m[1]
p m[2]
p m[3]
p m[2, 2]
p m[-1]
p m[1..3]

text = '私の誕生日は1960年10月1日です。'
if m = /(\d+)年(\d+)月(\d+)日/.match(text)
  # マッチした場合の処理、mをそのまま使える
else
  # マッチしない処理
end

m = /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/.match(text)
p m
p m[:year]
p m[:month]
p m[:day]
p m['year']
p m[1]

text = '私の誕生日は1960年10月1日です。'
if /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/ =~ text
  p "#{year} : #{month} : #{day}"
end

# if text =~ /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/

# scan
p '123 456 789'.scan(/\d+/)

# 正規表現に()があると、キャプチャされた部分が配列の配列になって帰ってくる
p '1977年7月17日 2016年12月31日'.scan(/(\d+)年(\d+)月(\d+)日/)

# グループ化はしたいが、キャプチャはせず文字列全体を取得したい場合に使う?:
p '1977年7月17日 2016年12月31日'.scan(/(?:\d+)年(?:\d+)月(?:\d+)日/)

# 正直これでもいい
p '1977年7月17日 2016年12月31日'.scan(/\d+年\d+月\d+日/)


text = '郵便番号は123-4567です'
p text[/\d{3}-\d{4}/]

# 複数マッチする場合最初の奴が返ってくる
text = '郵便番号は123-4567 456-7890です'
p text[/\d{3}-\d{4}/]

text = '私の誕生日は1977年7月17日です'
p text[/(\d+)年(\d+)月(\d+)日/]
p text[/(\d+)年(\d+)月(\d+)日/, 3]

p text.slice(/(\d+)年(\d+)月(\d+)日/)
p text.slice!(/(\d+)年(\d+)月(\d+)日/)
p text

text = "123,456-7890"

p text.split(',')
p text.split(/,|-/)

text = "123,456-7890"

p text.gsub(',', ':')
p text.gsub(/,|-/, ':')

text = '私の誕生日は1977年7月17日です'

p text.gsub(/(\d+)年(\d+)月(\d+)日/, '\1-\2-\3')
p text.gsub(
  /(?<year>\d+)年(?<month>\d+)月(?<day>\d+)日/,
  '\k<year>-\k<month>-\k<day>'
)


text = "123,456-7890"
hash = { ',' => ':', '-' => '/'}
p text.gsub(/,|-/, hash)

p text.gsub(/,|-/) { |matched| matched == ',' ? ':' : '/' }

text = '私の誕生日は1977年7月17日です'
text =~ /(\d+)年(\d+)月(\d+)日/