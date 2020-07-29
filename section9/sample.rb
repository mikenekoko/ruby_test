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

begin
  1 / 0
rescue => e
  p "エラークラス#{e.class}"
  p "エラーメッセージ#{e.message}"
  puts "バックトレース#{e.backtrace}"
  p e
end

begin
  1 / 0
rescue ZeroDivisionError => e
  puts e.backtrace
end

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