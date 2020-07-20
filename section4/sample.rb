numbers = [1,2,3,4]
sum = 0
numbers.each do |n|
  sum += n
end

sum

a = [1,2,3,1,2,3]
a.delete(2)
# -> [1,3,1,3]

a = [1,2,3,1,2,3]
a.delete_if do |n|
  n.odd?
end

a
# -> [2,2]

numbers = [1,2,3,4]
sum = 0
numbers.each do |n|
  sum_value = n.even? ? n*10 : n
  sum += sum_value
end

sum
# -> 64

numbers.each do |n| sum += n end
numbers.each { |n| sum += n } 

# map

numbers = [1,2,3,4,5]
new_numbers = []
numbers.each { |n| new_numbers << n * 10 }
new_numbers

# mapを使うとこんな感じで書ける

numbers = [1,2,3,4,5]
new_numbers = numbers.map { |n| n * 10 }

# select

numbers = [1,2,3,4,5,6]
even_numbers = numbers.select { |n| n.even? }
p even_numbers

# reject
numbers = [1,2,3,4,5,6]
even_numbers = numbers.reject { |n| n.even? }
p even_numbers

# find
numbers = [1,2,3,4,5,6]
even_number = numbers.find { |n| n.even? }
p even_number

# inject
numbers = [1,2,3,4]
sum = 0
numbers.each { |n| sum += n }
p sum

numbers = [1,2,3,4]
sum = numbers.inject(0) { |result, n| result + n }
p sum

# &
language = ['ruby', 'java', 'perl']
p language.map { |s| s.upcase }
p language.map(&:upcase)

numbers = [1,2,3,4,5,6]
p numbers.select { |n| n.odd? }
p numbers.select(&:odd?)

# 無理なパターン
# ブロックの中でメソッドではなく演算子を使っている
[1, 2, 3, 4, 5, 6].select { |n| n % 3 == 0 }

# ブロック内のメソッドで引数を渡している
[9, 10, 11, 12].map { |n| n.to_s(16) }

# ブロックの中で複数の分を実行している
[1, 2, 3, 4].map do |n|
  m = n * 4
  m.to_s
end

# range
p (1..5).class
p (1...5)

range = 1..5
p range.include?(4.9)
p range.include?(5)

range = 1...5
p range.include?(4.9)
p range.include?(5)

a = [1,2,3,4,5]
p a[1..3]

b = 'abcdef'
p b[1..3]

# case と合わせる
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

a = Array.new(5)
p a

a = Array.new(5, 0)
p a

a = Array.new(5) { |n| n % 3 + 1 }
p a

a = Array.new(5, 'default')
p a

str = a[0]
str.upcase!

p str
p a

a = Array.new(5) { 'default' }
p a

str = a[0]
str.upcase!

p str
p a


a = 'abcde'
a[0] = 'X'
p a

a = 'abcde'
a[1,3] = 'Y'
p a

a = 'abcde'
a << 'XYZ'
p a

fruits = ['apple', 'melon', 'orange']
fruits.each.with_index { |fruits, i| p "#{i}: #{fruits}"}

fruits = ['apple', 'orange', 'melon']
fruits.map.with_index { |fruits, i| p "#{i}: #{fruits}"}

p fruits
fruits.delete_if.with_index do |fruits, i|
  p i
  fruits.include?('a') && i.odd?
end
p fruits

p fruits.each