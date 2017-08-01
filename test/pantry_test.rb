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

  def test_check_stock_for
    pantry = Pantry.new

    assert_equal 0, pantry.stock_check("Cheese")
  end

  def test_restock
    pantry = Pantry.new

    pantry.restock("Cheese", 10)
    assert_equal 10, pantry.stock_check("Cheese")

    pantry.restock("Cheese", 20)
    assert_equal 30, pantry.stock_check("Cheese")
  end

  def test_convert_units
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Cayenne Pepper", 0.025)
    r.add_ingredient("Cheese", 75)
    r.add_ingredient("Flour", 500)
    pantry = Pantry.new

    converted = pantry.convert_units(r)
    expected_cayenne = {quantity: 25, units: "Milli-Units"}
    expected_cheese = {quantity: 75, units: "Universal Units"}
    expected_flour = {quantity: 5, units: "Centi-Units"}




    assert_instance_of Hash, converted
    assert_equal ["Cayenne Pepper", "Cheese", "Flour"], converted.keys
    assert_equal expected_cayenne, converted["Cayenne Pepper"]
    assert_equal expected_cheese, converted["Cheese"]
    assert_equal expected_flour, converted["Flour"]
  end

end
