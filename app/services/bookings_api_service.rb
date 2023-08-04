require 'net/http'
require 'json'
require 'money'
require 'money/bank/open_exchange_rates_bank'

class BookingsApiService
  BOOKINGS_API_URL = 'http://localhost:9292/api/bookings'.freeze

  def fetch
    process_bookings(fetch_bookings_data)
  end

  def fetch_bookings_data
    uri = URI(BOOKINGS_API_URL)
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body)['bookings'] if response.code == '200'
  rescue StandardError => e
    raise "Error fetching bookings data: #{e.message}"
  end

  def convert_to_usd(amount, currency)
    amount_in_currency = Money.new(amount, currency)
    amount_in_currency.exchange_to('USD').fractional
  rescue Money::Bank::UnknownRate
    amount.fractional
  end

  def calculate_amount_with_fees(amount)
    case amount
    when 0..1000
      amount * 1.05
    when 1001..10000
      amount * 1.03
    else
      amount * 1.02
    end
  end

  def calculate_quality_check(email, student_id, amount_with_fees, existing_students)
    quality_check = []
    quality_check << 'InvalidEmail' if invalid_email?(email)
    quality_check << 'DuplicatedPayment' if duplicated_payment?(student_id, existing_students)
    quality_check << 'AmountThreshold' if amount_with_fees > 1_000_000
    quality_check
  end

  def process_bookings(bookings_data)
    existing_students = []

    bookings_data.map do |booking|
      amount, student_currency, email, student_id, reference, amount_received = booking_attributes(booking) 
      
      amount_with_fees = calculate_amount_with_fees(amount)
      amount_with_fees_usd = convert_to_usd(amount_with_fees, student_currency)
      quality_check = calculate_quality_check(email, student_id, amount_with_fees_usd, existing_students)
      existing_students << student_id

      {
        reference: reference,
        amount: amount,
        amount_with_fees: amount_with_fees,
        amount_received: amount_received,
        quality_check: quality_check.join(', '),
        over_payment: over_payment?(amount_received, amount_with_fees),
        under_payment: under_payment?(amount_received, amount_with_fees)
      }
    end
  end

  def booking_attributes(booking)
    [
      booking['amount'],
      booking['currency_from'],
      booking['email'],
      booking['student_id'],
      booking['reference'],
      booking['amount_received']
    ]
  end

  def invalid_email?(email)
    !(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match?(email))
  end

  def duplicated_payment?(student_id, existing_students)
    existing_students.include?(student_id)
  end

  def over_payment?(amount_received, amount_with_fees)
    amount_received > amount_with_fees
  end

  def under_payment?(amount_received, amount_with_fees)
    amount_received < amount_with_fees
  end
end
