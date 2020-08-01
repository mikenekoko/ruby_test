def greeting
  p 'mike'
  yield
  p 'cat'
end

greeting do
  p 'neko'
end

def greeting2
  yield 'みけにゃ～'
end

greeting2 do |mike|
  p mike * 2
end

def greeting3(&mike)
  mike.call('みけにゃ～')
end

greeting3 do |mike|
  p mike * 2
end

hello_proc = Proc.new do
  p 'Hello!'
end

# ただ呼ぶだけじゃ動かないよ
hello_proc

# callする必要があるよ
hello_proc.call

add_proc = Proc.new { |a, b| a + b }
p add_proc.call(10, 20)

reverse_proc = Proc.new { |s| s.reverse }
p ['Ruby', 'Java'].map(&reverse_proc)

split_proc = :split.to_proc
p split_proc.call('a-b-c d')
p split_proc.call('a-b-c d', '-')

split_proc2 = Proc.new { |s, p| s.split(p) }
p split_proc2.call('a-b-c d')
p split_proc2.call('a-b-c d', '-')

def proc_return
  f = Proc.new { |n| return n * 10 }
  ret = [1, 2, 3].map(&f)
  "ret: #{ret}"
end

def lambda_return
  f = ->(n) { break n * 10 }
  ret = [1, 2, 3].map(&f)
  "ret: #{ret}"
end

p proc_return
p lambda_return