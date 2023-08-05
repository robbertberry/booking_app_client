require 'rails_helper'

RSpec.describe BookingsQualityCheckService do
  subject(:bookings_quality_check_service) { described_class.new }

  describe '#invalid_email?' do
    it 'returns true for an invalid email' do
      expect(bookings_quality_check_service.invalid_email?('invalid_email')).to be true
    end

    it 'returns false for a valid email' do
      expect(bookings_quality_check_service.invalid_email?('valid_email@example.com')).to be false
    end
  end

  describe '#duplicated_payment?' do
    let(:student_id) { 'STUDENT001' }
    let(:existing_students) { ['STUDENT001', 'STUDENT002'] }

    it 'returns true if the student_id is in the existing_students array' do
      expect(bookings_quality_check_service.duplicated_payment?(student_id, existing_students)).to be true
    end

    it 'returns false if the student_id is not in the existing_students array' do
      expect(bookings_quality_check_service.duplicated_payment?('STUDENT003', existing_students)).to be false
    end
  end

  describe '#over_payment?' do
    it 'returns true if amount_received is greater than amount_with_fees' do
      expect(bookings_quality_check_service.over_payment?(100, 50)).to be true
    end

    it 'returns false if amount_received is equal to amount_with_fees' do
      expect(bookings_quality_check_service.over_payment?(100, 100)).to be false
    end

    it 'returns false if amount_received is less than amount_with_fees' do
      expect(bookings_quality_check_service.over_payment?(50, 100)).to be false
    end
  end

  describe '#under_payment?' do
    it 'returns true if amount_received is less than amount_with_fees' do
      expect(bookings_quality_check_service.under_payment?(50, 100)).to be true
    end

    it 'returns false if amount_received is equal to amount_with_fees' do
      expect(bookings_quality_check_service.under_payment?(100, 100)).to be false
    end

    it 'returns false if amount_received is greater than amount_with_fees' do
      expect(bookings_quality_check_service.under_payment?(100, 50)).to be false
    end
  end

  describe '#calculate_amount_with_fees' do
    it 'calculates the amount with fees for 0 to 1000' do
      expect(bookings_quality_check_service.calculate_amount_with_fees(500)).to eq(525)
    end

    it 'calculates the amount with fees for 1001 to 10000' do
      expect(bookings_quality_check_service.calculate_amount_with_fees(5000)).to eq(5150)
    end

    it 'calculates the amount with fees for amounts above 10000' do
      expect(bookings_quality_check_service.calculate_amount_with_fees(15000)).to eq(15300)
    end
  end

  describe '#fetch_bookings_data' do
    it 'returns bookings data when the API call is successful' do
      bookings_data = { 'bookings' => [{ 'reference' => 'ref1', 'amount' => 100, 'amount_received' => 100 }] }
      response = double('response', code: '200', body: bookings_data.to_json)
      allow(Net::HTTP).to receive(:get_response).and_return(response)

      expect(bookings_quality_check_service.fetch_bookings_data).to eq(bookings_data['bookings'])
    end

    it 'raises an error when the API call fails' do
      allow(Net::HTTP).to receive(:get_response).and_raise(StandardError, 'API Error')

      expect { bookings_quality_check_service.fetch_bookings_data }.to raise_error('Error fetching bookings data: API Error')
    end
  end
end
