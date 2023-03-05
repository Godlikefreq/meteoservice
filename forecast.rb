require 'date'

class Forecast
  TIME_OF_DAY = %w[ночь утро день вечер].freeze
  CLOUDINESS = %w[Ясно Малооблачно Облачно Пасмурно].freeze

  def initialize(params)
    @date = params[:date]
    @time_of_day = params[:time_of_day]
    @temp_min = params[:temp_min]
    @temp_max = params[:temp_max]
    @wind = params[:date]
  end

  def self.read_from_xml(node)
    day = node.attributes['day']
    month = node.attributes['month']
    year = node.attributes['year']

    new(
      date: Date.parse("#{day}.#{month}.#{year}"),
      time_of_day: TIME_OF_DAY[node.attributes['tod'].to_i],
      temp_min: node.elements['TEMPERATURE'].attributes['min'].to_i,
      temp_max: node.elements['TEMPERATURE'].attributes['max'].to_i,
      wind: node.elements['WIND'].attributes['max'].to_i,
      cloudiness: CLOUDINESS[node.elements['PHENOMENA'].elements['cloudiness'].to_i]
    )
  end

  def to_s
    result = today? ? 'Сегодня' : @date.strftime('%d.%m.%Y')

    result << ", #{@time_of_day}\n" \
      "#{temperature_range_string}, ветер #{@max_wind} м/с, " \
      "#{@cloudiness}"

    result
  end

  def temperature_range_string
    result = ''
    result << '+' if @temp_min > 0
    result << "#{@temp_min}.."
    result << '+' if @temp_max > 0
    result << @temp_max.to_s
    result
  end

  def today?
    Date.today == @date
  end
end
