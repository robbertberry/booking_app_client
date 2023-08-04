require_relative '../services/bookings_api_service'

class PaymentsController < ApplicationController
  def with_quality_check
    begin
      @bookings_with_quality_check = BookingsApiService.new.fetch || []
    rescue StandardError => e
      @bookings_with_quality_check = []
      flash.now[:alert] = e.message
    end

    render :with_quality_check
  end
end
