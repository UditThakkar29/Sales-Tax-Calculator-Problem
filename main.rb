require_relative "tax"

include Store

class TaxCalculator
  EXEMPT_TAX = 0
  NORMAL_TAX = 10
  IMPORTED_TAX = 5

  def calculate(item)
    if item.check_item_exempt == true
      tax = exempt_tax(item.p_price)
    else
      tax = calculate_basic(item.p_price)
    end
    puts "value for check #{item.check_item_exempt}"
    puts "Printing #{item.p_name} tax without import #{tax}"
    if item.isImported
      tax += calculate_imported(item.p_price)
    end
    puts "Printing #{item.p_name}  tax after import #{tax}"
    tax
  end

  def exempt_tax(price)
    tax = price + price * (EXEMPT_TAX)/100
    tax
  end

  def calculate_basic(price)
    tax = price + price * (NORMAL_TAX)/100
    tax
  end
  def calculate_imported(price)
    tax = price * (IMPORTED_TAX)/100
    tax
  end
end

class Cart
  def initialize(items)
    @items = items
  end

  def total_bill
    calc = TaxCalculator.new
    @tax_arr = []
    @items.map do |item|
      tax = calc.calculate(item)
      @tax_arr.push(tax)
    end
  end
  def output_tax
    puts @tax_arr.inspect
  end
end

class Item
  attr_accessor :p_name, :p_price, :p_quant, :imported, :p_food, :p_med

  def initialize(name,price,quant,imported,food,med)
    @p_name = name
    @p_price = price
    @p_quant = quant
    @imported = imported
    @p_food = food
    @p_med = med
    puts "#{@p_name} #{@p_price} #{@p_quant} #{@imported}"
  end

  def isImported
    @imported
  end
  def is_food
    return @p_food
  end
  def is_medicine
    return @p_med
  end
  def check_item_exempt
    puts "inside exempt"
    if is_food or is_medicine or @p_name.downcase == "book"
      return true
    else
      return false
    end
  end

end

def start
  puts "Welcome to the shop"

  get_all_products
  puts $products.inspect
  items = []
  loop do
    puts "Do you want a medicine or food item f for food and m for medicine and n for none"
    i_type = gets.chomp
    if i_type == "f"
      food = 1
      med = 0
    elsif i_type == "m"
      med = 1
      food = 0
    end
    puts "Enter the name of the product done if no more products"
    product = gets.chomp()
    if product == "done"
      break
    end
    puts "Enter the price of the product"
    price = gets.chomp().to_i
    puts "Enter the quantity"
    quant = gets.chomp.to_i
    puts "Is your item imported Enter 1 for imported 0 for not imported"
    imported = gets.chomp().to_i
    items << Item.new(product,price,quant,imported,food,med)
  end
  # puts "Item 1 is imported #{items[0].isImported?}"
  cart = Cart.new(items)
  cart.total_bill
  cart.output_tax
end

start
