# $products = ["Books","Muisc CD","Chocolate Bar","Imported Perfume","Imported Chocolate Box", "Perfume","Headache Pills"]
module Store
  PRODUCTS = ["Books","Muisc CD","Chocolate Bar","Imported Perfume","Imported Chocolate Box", "Perfume","Headache Pills"]
  def get_all_products
    puts "\t\t\t\t\t\t\tWelcome to the shop"
    puts "\t\t\t\t\t   All the available products are listed below"
    i = 1
    Store::PRODUCTS.each_with_index do |ele,idx|
      puts (idx.to_s + " " + ele)
    end
  end

end


