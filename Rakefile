require 'rake/testtask'

# タスクの名前がtestになる
Rake::TestTask.new do |t|
  t.pattern = 'section*/test/*_test.rb'
end

# testタスクをデフォルトのタスクに設定する
# デフォルトに設定することで、 rake とうつだけでテストが走るようになる
task default: :test