require 'money'
require 'savon'

class Money
  module Bank
    module CbrRatesLoader
      CBR_SERVICE_URL = 'http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL'

      def load_rates(date)
        client = Savon::Client.new(wsdl: CBR_SERVICE_URL, log: false, log_level: :error)
        response = client.call(:get_curs_on_date, message: { 'On_date' => date.strftime('%Y-%m-%dT%H:%M:%S') })
        rates = response.body[:get_curs_on_date_response][:get_curs_on_date_result][:diffgram][:valute_data][:valute_curs_on_date]

        local_currencies = Money::Currency.table.map { |currency| currency.last[:iso_code] }
        rates.each do |rate|
          begin
            if local_currencies.include? rate[:vch_code]
              internal_set_rate(date, 'RUB', rate[:vch_code], 1/ (rate[:vcurs].to_f / rate[:vnom].to_i))
            end
          rescue Money::Currency::UnknownCurrency
          end
        end
      end
    end
  end
end