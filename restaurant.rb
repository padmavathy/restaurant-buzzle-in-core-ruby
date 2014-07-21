require 'open-uri'
require 'csv'

class Food
	def initialize(csv_file)
		@total_rest_hash = {}
		@food_items = []
		 form_hash(csv_file)
	 end
	 
	def form_hash(url)
	CSV.new(open(url)).each do |line|
		 restaurant_id = line[0].to_i
     rate = line[1].to_f
     food_menu = line[2..-1].map(&:strip).join(",")
		 item_id = @food_items.include?(food_menu) ? @food_items.index(food_menu)  : @food_items.push(food_menu).length - 1
		 @total_rest_hash[restaurant_id] = {} unless @total_rest_hash.has_key? restaurant_id
		 @total_rest_hash[restaurant_id][item_id]  = rate
   end
 end
   
	 def program(item_list)
		 @minimum_price_rest = []
		 @food_min_price = [], @item_id = []
		 unless item_list.empty? 
			 item_list.each_with_index do |sing_item,index|
				 is_item = @food_items.include?(sing_item.downcase) ? 1 : 0
				 @item_id[index] = @food_items.map {|food| @food_items.index(food) if food.match(/#{sing_item.downcase}/)}.compact
				  if is_item == 0
						 puts "Please check your item list"
						 return
					 end
				 end		
				@total_rest_hash.each do |key,value|
				     total = min_price(key)
						@minimum_price_rest << [key, total] if total > 0
					end
					if @minimum_price_rest.empty? 
						return nil 
					else			
            results = best_price_restaurant			
						puts "Food Price $#{results[1]} and Restaurant #{results[0]}"
					end
			end
	 end
	 
	 def min_price(restau)
		 total = {}
		 check = 0
		 @item_id.each_with_index do |item_arr,index|
			  total[index] = [] 
				 item_arr.each do |ite|
			     total[index]  << @total_rest_hash[restau][ite] if @total_rest_hash[restau].has_key? ite
        end
				 total[index].empty? ? check = 1 : total[index] = total[index].first
			end
		  check != 0 ? 0 : total.values.inject(:+) unless total.values.compact.empty? 
	 end
end

def best_price_restaurant
	price = @minimum_price_rest[0][1]
	restaurant =  @minimum_price_rest[0][0]
	@minimum_price_rest.each do |res_id,food_price|
		  restaurant = res_id if food_price < price
			price = food_price if food_price < price
		end
		return [restaurant,price]
end
