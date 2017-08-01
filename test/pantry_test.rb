require './lib/pantry'
require 'minitest/autorun'
require 'minitest/pride'

class PantryTest < Minitest::Test
  def test_it_exists
    pantry = Pantry.new

    assert_instance_of Pantry, pantry
  end

  def test_stock_initializes_empty
    pantry = Pantry.new

    assert_instance_of Hash, pantry.stock
    assert pantry.stock.empty?
  end

end
