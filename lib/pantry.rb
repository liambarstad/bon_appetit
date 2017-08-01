require './lib/recipe'
require 'pry'

class Pantry
  attr_reader :stock,
              :cookbook
  def initialize
    @stock = {}
    @cookbook = []
  end

  private

    def convert(amount)
      if amount < 1
        {quantity: (amount * 1000), units: "Milli-Units"}
      elsif amount > 100
        {quantity: (amount / 100), units: "Centi-Units"}
      else
        {quantity: amount, units: "Universal Units"}
      end
    end

  public

    def stock_check(food)
      if @stock[food] == nil
        return 0
      else
        return @stock[food]
      end
    end

    def restock(food_name, amount)
      if @stock.keys.include?(food_name)
        @stock[food_name] += amount
      else
        @stock.store(food_name, amount)
      end
    end

    def convert_units(recipe)
      recipe.ingredients.reduce({}) do |result, ingredient_pair|
        name = ingredient_pair[0]
        amount = convert(ingredient_pair[1])
        result.store(name, amount)
        result
      end
    end

    def add_to_cookbook(recipe)
      @cookbook << recipe
    end

    def what_can_i_make
      recipes = @cookbook.find_all do |recipe|
        recipe.ingredients.all? do |ingredient_pair|
          @stock[ingredient_pair[0]] >= ingredient_pair[1]
        end
      end
      recipes.reduce([]) {|result, recipe| result << recipe.name}
    end
end
