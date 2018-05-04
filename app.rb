require 'sinatra'
require 'stripe'
require 'stripe_event'
require_relative 'refactored_pizza.rb'

enable :sessions

get '/' do
	session[:current_order] = Array.new
	erb :welcome_page0
end

post '/on-to-size' do
	redirect '/size'
end

get '/size' do
	session[:pizza] = {
		'type' => "pizza",
		'ingredients' => []
	}
	erb :pizza_size_page1
end

post '/on-to-crust' do
	convert_pizza(params[:selection], session[:pizza])
	redirect '/crust'
end

get '/crust' do
	erb :pizza_crust_page2
end

post '/on-to-meats' do
	convert_pizza(params[:selection], session[:pizza])
	redirect '/meats'
end

get '/meats' do
	erb :meats_page3
end

post '/on-to-veggies' do
	convert_pizza(params[:selection], session[:pizza])
	redirect '/veggies'
end

get '/veggies' do
	erb :veggies_page4
end

post '/on-to-special-toppings' do
	convert_pizza(params[:selection], session[:pizza])
	redirect '/special-toppings'
end

get '/special-toppings' do
	erb :special_toppings_page5
end

post '/on-to-sauces' do
	convert_pizza(params[:selection], session[:pizza])
	redirect '/sauces'
end

get '/sauces' do
	erb :sauces_page6
end

post '/on-to-extra-toppings' do
	convert_pizza(params[:selection], session[:pizza])
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
	convert_pizza(params[:selection], session[:pizza])
	session[:current_order].push(session[:pizza])
	redirect '/salad'
end

get '/salad' do
	erb :salad_page8
end

post '/on-to-wings' do
	convert_sides(params[:selection], session[:current_order], params[:quantity].to_i)

	redirect '/wings'
end

get '/wings' do
	erb :wings_page9
end

post '/on-to-drinks' do
	convert_sides(params[:selection], session[:current_order], params[:quantity].to_i)
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
	convert_sides(params[:selection], session[:current_order], params[:quantity].to_i)
	redirect '/pasta'
end

get '/pasta' do
	erb :pasta_page11
end

post '/on-to-almost-final' do
	convert_sides(params[:selection], session[:current_order], params[:quantity].to_i)
	redirect '/almost-final'
end

get '/almost-final' do
	erb :almost_final_page12, locals:{order: session[:current_order]}
end

post "/get-rid-of-these" do
	if params[:pizza_remove] != nil
		delete_pizza_ingredients(session[:current_order], params[:pizza_remove])
	end
	if params[:side_remove] != nil
		delete_sides(session[:current_order], params[:side_remove])
	end
	redirect "/almost-final"
end

get '/final' do
	erb :final_page13, locals:{order:session[:current_order]}
end

post '/on-to-checkout' do
	session[:total_price] = add_order_totals(session[:current_order], params[:delivery].to_i)
	redirect "/checkout"
end

get '/checkout' do
	erb :checkout, locals:{price: session[:total_price]}
end

post '/on-to-thank-you' do
	if params[:payment] = "stripe"
		redirect "/stripe"
	else
		redirect "/thanks"
	end
end

get '/stripe' do
	erb :stripe, locals:{price: session[:total_price]}
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
