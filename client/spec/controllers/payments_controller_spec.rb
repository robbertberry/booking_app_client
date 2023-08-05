require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe '#with_quality_check' do
    it 'renders the :with_quality_check template' do
      bookings_api_service = instance_double(BookingsQualityCheckService)
      allow(BookingsQualityCheckService).to receive(:new).and_return(bookings_api_service)
      allow(bookings_api_service).to receive(:fetch).and_return({ 'bookings' => [] })

      get :with_quality_check

      expect(response).to render_template(:with_quality_check)
    end

    it 'assigns the correct instance variables' do
      bookings_api_service = instance_double(BookingsQualityCheckService)
      bookings_data = { 'bookings' => [{ 'reference' => 'ref1', 'amount' => 100, 'amount_received' => 100 }] }
      allow(BookingsQualityCheckService).to receive(:new).and_return(bookings_api_service)
      allow(bookings_api_service).to receive(:fetch).and_return(bookings_data)

      get :with_quality_check
    end

    it 'handles error while fetching bookings data' do
      bookings_api_service = instance_double(BookingsQualityCheckService)
      allow(BookingsQualityCheckService).to receive(:new).and_return(bookings_api_service)
      allow(bookings_api_service).to receive(:fetch).and_raise('API Error')

      get :with_quality_check

      expect(response).to render_template(:with_quality_check)
      expect(flash.now[:alert]).to eq('API Error')
    end
  end
end
