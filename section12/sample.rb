p Time.new(2017, 1, 31, 23, 30, 59)

require 'date'
p Date.new(2017, 1, 31)
p DateTime.new(2017, 1, 31, 23, 30, 59)

File.open('../section3/sample.rb', 'r') do |f|
  p f.readlines.count
end

File.open('./test.txt', 'w') do |f|
  f.puts 'Hello, world!'
end

require 'fileutils'
# FileUtils.mv('./test.txt', './hello_world.txt')

require 'pathname'
lib = Pathname.new('./README.md')
p lib.file?
p lib.directory?

require 'json'
user = {name:'mike', email: 'hoge@com'}
p user.to_json

user2 = {name: :mike}
p user2.to_json

p JSON.parse(user.to_json)

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

# 要素追加
users['mike']['sex'] = :man
p users

# YAMLに変換
p YAML.dump(users)

p ENV['MY_NAME']
p ARGV[0]
p ARGV[1]

code = '[1, 2, 3].map{ |n| n * 10 }'
p eval(code)

puts `cat ../section3/sample.rb`