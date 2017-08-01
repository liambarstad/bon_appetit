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

  def test_add_to_cookbook
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Brine Shot")
    r2.add_ingredient("Brine", 10)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    assert_equal [r1, r2, r3], pantry.cookbook
  end

  def test_what_can_i_make
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Brine Shot")
    r2.add_ingredient("Brine", 10)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    assert_equal ["Brine Shot", "Peanuts"], pantry.what_can_i_make
  end

  def test_how_many_can_i_make
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Brine Shot")
    r2.add_ingredient("Brine", 10)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    expected = {"Brine Shot" => 4, "Peanuts" => 2}

    assert_equal expected, pantry.how_many_can_i_make
  end

end
