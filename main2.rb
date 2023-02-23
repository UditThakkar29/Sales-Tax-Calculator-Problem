require_relative "tax"

include Store

class TaxCalculator
  EXEMPT_TAX = 0
  NORMAL_TAX = 10
  IMPORTED_TAX = 5

  def calculate(item)
    tax = 0
    if item.check_item_exempt?
      tax = exempt_tax(item.p_price)
    else
      tax = calculate_basic(item.p_price)
    end
    # puts "value for check #{item.check_item_exempt?}"
    # puts "Printing #{item.p_name} tax without import #{tax}"
    # puts "value for isImpored #{item.isImported?}"
    if item.isImported?
      tax += calculate_imported(item.p_price)
      # puts "Printing #{item.p_name}  tax after import #{tax}"
    end

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

class Receipt
  attr_accessor :tax_array, :cust_name, :cust_phone
  def initialize(tax_array)
    @tax_array = tax_array
  end
  def Printing
    # puts @tax_array.inspect
    puts `clear`
    puts "Enter Your Name here"
    @cust_name = gets.chomp
    puts "Enter your phone no"
    @cust_phone = gets.chomp
    # puts `clear`
    total_tax = 0
    total_bill = 0
    puts "\t\t\t\t\t Hello #{@cust_name}!"
    puts "\t\t\t\t\t Thank You for Shopping"
    puts "\t\t\t\t\t Here is you Receipt"
    @tax_array.each do |arr|
      quant = arr[3]
      tax = (arr[0] - arr[1])*quant
      total_tax += tax
      total_bill+=arr[0] * quant
      name = arr[2]
      quant = arr[3]
      puts "\t\t\t\t\t #{quant} #{name} : #{arr[0]*quant.round(2)}"
    end
    puts "\t\t\t\t\t Sales Tax: #{total_tax.round(2)}"
    puts "\t\t\t\t\t Total Bill: #{total_bill.round(2)}"
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
      arr = [tax,item.p_price,item.p_name,item.p_quant]
      h = Hash.new
      h[item.p_name] = tax
      @tax_arr.push(arr)
    end
  end
  def output_tax
    rec = Receipt.new(@tax_arr)
    rec.Printing
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
    # puts "#{@p_name} #{@p_price} #{@p_quant} #{@imported}"
  end

  def isImported?
    @imported
  end
  def is_food
    return @p_food
  end
  def is_medicine
    return @p_med
  end
  def check_item_exempt?
    # puts "inside exempt"
    if is_food or is_medicine or @p_name.downcase == "book"
      return true
    else
      return false
    end
  end

end

class Input
  def self.check_type
    flag = true
    ans = []
    while flag
      puts "Enter the type of product you want to purchase"
      puts "m for Medicine"
      puts "f for food"
      puts "n for other"
      type = gets.chomp
      if type!="m" and type!="f" and type!="n"
        puts "Wrong type enter again"
      else
        flag = false
      end
      if type == "f"
        food = true
        med = false
      elsif type == "m"
        med = true
        food = false
      end
      ans << food
      ans << med
      puts ans.inspect
      return ans
    end
  end
  def self.basic_info
    puts "Enter the product details in the following order"
    puts "quantity name at price"
    product = gets.chomp
    product_list = product.split("at")
    # puts product_list.inspect
    quantity = product_list[0].split(" ")[0].to_i
    name = product_list[0]
    price = product_list[1].to_f
    imported = product_list[0].include? ("imported")
    final_list = [quantity,name,price,imported]
    # puts final_list.inspect
    return final_list
  end

  def self.create_item_object(type,info)
    food = type[0]
    med = type[1]
    product = info[1]
    quant = info[0]
    price = info[2]
    imported = info[3]
    # puts [product,price,quant,imported,food,med].inspect
    $items << Item.new(product,price,quant,imported,food,med)
  end

end

def start
  get_all_products
  puts $products.inspect
  $items = []
  puts "Enter the number of products you want to purchase."
  count = gets.chomp.to_i
  while count>0
    type = Input.check_type
    basic_info = Input.basic_info
    Input.create_item_object(type,basic_info)
    count-=1
    if count == 0
      puts "Do you want to add any more no of items"
      puts "Enter the amount or enter 0"
      extra = gets.chomp.to_i
      count += extra
    end
  end

  # puts "Item 1 is imported #{items[0].isImported?}"
  cart = Cart.new($items)
  cart.total_bill
  cart.output_tax

end

puts `clear`
start
