require 'money'
require 'date'
require 'savon'

require File.expand_path(File.dirname(__FILE__)) + "/cbr_rates_loader"

class Money
  module Bank
    class InvalidCache < StandardError ; end

    class CbrHistoricalRates < Money::Bank::VariableExchange
      include Money::Bank::CbrRatesLoader

      def add_rate(date, from, to, rate)
        set_rate(date, from, to, rate)
      end

      def set_rate(date, from, to, rate)
        @mutex.synchronize do
          internal_set_rate(date, from, to, rate)
        end
      end

      def get_rate(date, from, to)
        @mutex.syncronize do
          unless existing_rates = @rates[date.to_s]
            load_rates(date)
            existing_rates = @rates[date.to_s]
          end
          if existing_rates
            existing_rates[rate_key_for(from, to)] || indirect_rate(existing_rates,from, to)
          end
        end
      end

      def indirect_rate(existing_rates, from, to)
        from_base_rate = existing_rates[rate_key_for('RUB', from)]
        to_base_rate = existing_rates[rate_key_for('RUB', to)]
        to_base_rate / from_base_rate
      end

      def exchange_with(*args)
        date, from, to_currency = args.length == 2 ? [Date.today] + args : args

        return from if same_currency?(from.currency, to_currency)

        rate = get_rate(date, from.currency, to_currency)
        unless rate
          raise UnknownRate, "No conversion rate available for #{date} '#{from.currency.iso_code}' -> '#{to_currency}'"
        end
        _to_currency_  = Currency.wrap(to_currency)

        cents = BigDecimal.new(from.cents.to_s) / (BigDecimal.new(from.currency.subunit_to_unit.to_s) / BigDecimal.new(_to_currency_.subunit_to_unit.to_s))

        ex = cents * BigDecimal.new(rate.to_s)
        ex = ex.to_f
        ex = if block_given?
               yield ex
             elsif @rounding_method
               @rounding_method.call(ex)
             else
               ex.to_s.to_i
             end
        Money.new(ex, _to_currency_)
      end

      private
      def rate_key_for(from, to)
        "#{Currency.wrap(from).iso_code}_TO_#{Currency.wrap(to).iso_code}".upcase
      end

      def internal_set_rate(date, from, to, rate)
        if Money::Currency.find(from) && Money::Currency.find(to)
          date_rates = @rates[date.to_s] ||= {}
          date_rates[rate_key_for(from, to)] = rate
          date_rates[rate_key_for(to, from)] =  1.0 / rate
        end
      end
    end
  end
end