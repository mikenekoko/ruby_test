require 'minitest/autorun'
require './lib/rgb.rb'

class RgbTest < Minitest::Test
  def test_to_hex
    assert_equal '#000000', to_hex(0, 0, 0)
    assert_equal '#ffffff', to_hex(255, 255, 255)
    assert_equal '#043c78', to_hex(4, 60, 120)
  end

  def test_to_inits
    assert_equal [0, 0, 0], to_inits('#000000')
    assert_equal [255, 255, 255], to_inits('#ffffff')
    assert_equal [4, 60, 120], to_inits('#043c78')
  end
end