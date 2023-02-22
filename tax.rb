$products = ["Books","Muisc CD","Chocolate Bar","Imported Perfume","Imported Chocolate Box", "Perfume","Headache Pills"]
module Store

  def get_all_products
    puts "\t\t\t\t\t\t\tWelcome to the shop"
    puts "\t\t\t\t\t   All the available products are listed below"
    i = 1
    $products.each do |ele|
      puts (i.to_s + " " + ele)
      i+=1
    end
  end

end


