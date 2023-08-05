require 'money'
require 'money/bank/open_exchange_rates_bank'

bank = Money::Bank::OpenExchangeRatesBank.new

bank.app_id = ENV['OPEN_EXCHANGE_RATES_APP_ID']
bank.update_rates
bank.ttl_in_seconds = 86400
bank.source = 'USD'
bank.refresh_rates
bank.force_refresh_rate_on_expire = true
Money.default_bank = bank
bank.add_rate('USD', 'EUR', 0.9)
bank.add_rate('USD', 'CAD', 1.35)
