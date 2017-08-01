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

    def convert_decimal(amount)
      result = []
      whole_units = (amount / 1).floor
      milli_units = ((amount % 1).round(3) * 1000).to_i
      if milli_units > 1
        result << {quantity: milli_units, units: "Milli-Units"}
      end
      if whole_units >= 1
        result << {quantity: whole_units, units: "Universal Units"}
      end
      result
      # if amount < 1
      #   result = [{quantity: (amount * 1000), units: "Milli-Units"}]
      # elsif amount % 1 != 0
      #   result = [{quantity: ((amount - whole_units).round(3) * 1000).to_int, units: "Milli-Units"},
      #   {quantity: whole_units, units: "Universal Units"}]
      # else
      #   result = [{quantity: amount, units: "Universal Units"}]
      # end
      # result
    end

    def convert(amount)
      result = convert_decimal(amount)
      if amount > 100
        result.unshift({quantity: (amount / 100), units: "Centi-Units"})
        result.last[:quantity] = amount % 100
      end
      result
    end

    def find_least_common_multiple(recipe)
      lowest_ingredient = recipe.ingredients.min_by do |ingredient|
        (@stock[ingredient[0]] / ingredient[1]).floor
      end
      (@stock[lowest_ingredient[0]] / lowest_ingredient[1]).floor
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

    def how_many_can_i_make
      what_can_i_make.reduce({}) do |result, name|
        operating_recipe = @cookbook.find {|recipe| recipe.name == name}
        number = find_least_common_multiple(operating_recipe)
        result.store(name, number)
        result
      end
    end
end
