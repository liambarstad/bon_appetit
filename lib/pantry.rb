class Pantry
  attr_reader :stock
  def initialize
    @stock = {}
  end

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
end
