def convert_pizza(params, session)
	selection = params.split(",")
	session["ingredients"] << {'ingredient' => selection[0],'price' => selection[1].to_f}
end

def convert_sides(params, session, quantity)
	selection = params.split(",")
	side_hash = {
		'name' => selection[0],
		"price" => selection[1].to_f,
	}

	quantity.times do
		session.push side_hash
	end
end

def delete_pizza_ingredients(session, index_array)
	index_array.reverse!
	b = Array.new
	which_pizza = Array.new
	ingredient_to_remove = Array.new

	index_array.each do |i|
		b << i.split("@")
	end

	b.each do |i|
		i[0] = i[0].to_i
		i[1] = i[1].to_i
		which_pizza << i[0]
		ingredient_to_remove << i[1]
	end
	puts """






	b = #{b}
	which_pizza = #{which_pizza}
	ingredient_to_remove = #{ingredient_to_remove}






	"""
	b.length.times do |x|
		session[which_pizza[x]]["ingredients"].delete_at(ingredient_to_remove[x])
	end
end

def delete_sides(session, index_array)
	index_array.reverse!

	index_array.each do |i|
		session.delete_at(i.to_i)
	end
end

def convert_input(params) #converts the meats input into a usable array.
	converted = []
	if params[0].include?("none")
		converted = "none"
	else
		params.each do |item|
			conv = item.split('!!')
			# conv[1] = conv[1].to_i #converts price into integer
			converted.push conv
		end
	end

	return converted
end

def add_order_totals(order=[{"type"=>"pizza", "ingredients"=>[{"price" => 5}]}, {"price" => 15}], delivery = 5)
	subtotal = 0.to_f

	order.each do |item|
		if item["type"] == "pizza"
			item["ingredients"].each do |ingredient|
				subtotal += ingredient["price"].to_f
			end
		else
			subtotal += item["price"].to_f
		end
	end
	tax = subtotal * 0.06.to_f
	total = (subtotal + tax + delivery).to_f

	price = {
		"subtotal" => subtotal,
		"tax" => tax,
		"total" => (subtotal + tax + delivery).to_f,
		"delivery" => delivery
	}
	return price
end

def size
	{"small crust" => 2, "medium crust" => 3, "large crust" => 4, "XL crust" => 5}
end

def crust
	{"Pan crust" => 0, "Stuffed crust" => 2, "Bacon stuffed crust" => 3}
end

def meats
	{"none" => 0, "Chicken" => 2, "Pepperoni" => 1, "Sausage" => 1, "Bacon" => 2}
end

def veggies
	{"none" => 0, "Tomato" => 1, "Pineapple" => 2, "Spinach" => 1}
end

def special_toppings
	{"none" => 0, "Bbq sauce" => 2, "Buffalo sauce" => 2}
end

def sauces
	{"none" => 0, "Alfredo sauce" => 0, "Bbq sauce" => 0, "Tomato sauce" => 0, "Marinara sauce" => 0}
end

def extra_toppings
	{"none" => 0, "Double pepperoni" => 1, "Extra cheese" => 1, "Double chicken" => 3,}
end

def salad
	{"none" => 0, "Caesar Salad" => 10, "Veggie Salad" => 10}
end

def wings
	{"none" => 0, "Kentucky bourbon" => 2, "Garlic" => 2, "Buffalo" => 3}
end

def drinks
	{"none" => 0, "Water" => 1, "Coca-Cola" => 2, "Powerade" => 2, "Tea" => 2, "Sprite" => 2}
end

def pasta
	{"none" => 0, "Chicken Alfredo" => 8, "Lasagne" => 8}
end
