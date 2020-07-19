require 'minitest/autorun'

class SampleTest < Minitest::Test
  def test_sample
    assert_equal 'RUBY', 'ruby'.capitalize # 最初の1文字だけ大文字にするメソッド（一生使わなさそう）
  end
end

