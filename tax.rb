$products = ["Books","Muisc CD","Chocolate Bar","Imported Perfume","Imported Chocolate Box", "Perfume","Headache Pills"]
module Store

  def get_all_products
    i = 1
    $products.each do |ele|
      puts (i.to_s + " " + ele)
      i+=1
    end
  end

end


