require 'net/http'
require 'rexml/document'

require_relative 'forecast'
CITIES_LIST = {
  'Москва': 32277,
  'Санкт-Петербург': 69,
  'Казань': 34796,
  'Набережные Челны': 12,
  'Пермь': 59,
  'Екатеринбург': 122,
  'Омск': 128,
  'Новосибирск': 99,
  'Красноярск': 146,
}.freeze

cities = CITIES_LIST.keys

puts "Погоду для какого города Вы хотите узнать?"
cities.each.with_index(1) do |city, index|
  puts "#{index}. #{city}"
end

user_choice = -1
until user_choice.between?(1, cities.size)
  puts "Выберите город из списка"
  user_choice = STDIN.gets.to_i
end

id = CITIES_LIST[cities[user_choice - 1]]

URL = "https://www.meteoservice.ru/en/export/gismeteo?point=#{id}".freeze

response = Net::HTTP.get_response(URI.parse(URL))

doc = REXML::Document.new(response.body)

city_name = URI.decode_www_form_component(doc.root.elements['REPORT/TOWN'].attributes['sname'])

forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a

puts city_name
forecast_nodes.each do |node|
  puts Forecast.read_from_xml(node)
  puts
end
