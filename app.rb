require 'sinatra'
require_relative 'refactored_pizza.rb'

enable :sessions

get '/' do
	session[:total_price] = 0
	session[:final_order] = []
	erb :welcome_page0
end

post '/on-to-size' do
	redirect '/size'
end

get '/size' do
	session[:pizza] = []
	erb :pizza_size_page1
end

post '/back-to-size' do
	session[:pizza].pop
	redirect '/size'
end

post '/on-to-crust' do
	session[:pizza].push(params.values)
	redirect '/crust'
end

get '/crust' do
	erb :pizza_crust_page2
end

post '/back-to-crust' do
	session[:pizza].pop
	redirect '/crust'
end

post '/on-to-meats' do
	session[:pizza].push(params.values)
	redirect '/meats'
end

get '/meats' do
	erb :meats_page3
end

post '/back-to-meats' do
	session[:pizza].pop
	redirect '/meats'
end

post '/on-to-veggies' do
	selected_meats = convert_input(params[:meats])
	if selected_meats != "none"
		session[:pizza].push selected_meats
	end
	redirect '/veggies'
end

get '/veggies' do
	p session[:pizza]
	erb :veggies_page4
end

post '/back-to-veggies' do
	session[:pizza].pop
	redirect '/veggies'
end

post '/on-to-special-toppings' do
	if params[:veggies].include?("none")
		#do nothing
	else
		session[:pizza].push(params.values)
	end
	redirect '/special-toppings'
end

get '/special-toppings' do
	erb :special_toppings_page5
end

post '/back-to-special-toppings' do
	session[:pizza].pop
	redirect '/special-toppings'
end

post '/on-to-sauces' do
	if params[:special_toppings].include?("none")
		#do nothing
	else
		session[:pizza].push(params.values)
	end
	redirect '/sauces'
end

get '/sauces' do
	erb :sauces_page6
end

post '/back-to-sauces' do
	session[:pizza].pop
	redirect '/sauces'
end

post '/on-to-extra-toppings' do
	if params[:sauces].include?("none")
		#do nothing
	else
		session[:pizza].push(params.values)
	end
	redirect '/extra-toppings'
end

get '/extra-toppings' do
	erb :extra_toppings_page7
end

post '/on-to-extra-toppings' do
	session[:pizza].pop
	redirect '/extra-toppings'
end

post '/on-to-salad' do
	if params[:extra_toppings].include?("none")
		#do nothing
	else
		session[:pizza].push(params.values)
	end
	redirect '/salad'
end

get '/salad' do
	erb :salad_page8
end

post '/back-to-salad' do
	session[:pizza].pop
	redirect '/salad'
end

post '/on-to-wings' do
	quantity = params[:quantity].to_i
	if params[:salad].include?("none")
		#do nothing
	else
		quantity.times do
			session[:pizza].push(params[:salad])
		end
	end
	redirect '/wings'
end

get '/wings' do
	erb :wings_page9
end

post '/back-to-wings' do
	session[:pizza].pop
	redirect '/wings'
end

post '/on-to-drinks' do
	quantity = params[:quantity].to_i
	if params[:wings].include?("none")
		#do nothing
	else
		quantity.times do
			session[:pizza].push(params[:wings])
		end
	end
	redirect '/drinks'
end

get '/drinks' do
	erb :drinks_page10
end

post '/back-to-drinks' do
	session[:pizza].pop
	redirect '/drinks'
end

post '/on-to-pasta' do
	quantity = params[:quantity].to_i
	if params[:drinks].include?("none")
		#do nothing
	else
		quantity.times do
			session[:pizza].push(params[:drinks])
		end
	end
	redirect '/pasta'
end

get '/pasta' do
	erb :pasta_page11
end

post '/on-to-almost-final' do
	quantity = params[:quantity].to_i
	if params[:pasta].include?("none")
		#do nothing
	else
		quantity.times do
			session[:pizza].push(params[:pasta])
		end
	end
	redirect '/almost-final'
end

get '/almost-final' do
	pizza = []
	puts "this is session pizza #{session[:pizza]}"
	session[:pizza].each do |ingredient|
		if ingredient.class == String
			pizza << ingredient.split(", ")
		else
			pizza << ingredient
		end
	end
	session[:pizza] = pizza
	erb :almost_final_page12, locals:{pizza: pizza}
end

post "/get-rid-of-these" do
	final_ingredients = params[:ingredients]
	session[:pizza] = final_ingredients
	redirect "/almost-final"
end

post '/on-to-final' do
	session[:final_order].push (session[:pizza])
	redirect '/final'
end

get '/final' do
	pizza = []
	session[:final_order] = pizza
	pizza = session[:pizza].flatten
	pizza.map! {|s| s[/[\d.,]+/] }
	pizza.each do |prices|
		session[:total_price] += prices.to_i
	end
	session[:total_price]
	erb :final_page13, locals:{total_price: session[:total_price], cart:pizza}
end

post '/on-to-checkout' do
	session[:total_price] += params[:delivery?].to_i
	redirect "/checkout"
end

get '/checkout' do
	erb :checkout, locals:{total_price: session[:total_price]}
end

post '/on-to-thank-you' do
	redirect "/thanks"
end

get '/thanks' do
	erb :thanks
end

post '/more-pizza' do
	session[:final_order].push(session[:pizza])
	session[:pizza].clear
	redirect "/size"
end

get '/news' do
	erb :news
end

get '/about' do
	erb :about
end

get '/contact' do
	erb :contact, :layout => :droids
end
