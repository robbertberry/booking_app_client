class PaymentsController < ApplicationController
  def with_quality_check
    begin
      @bookings_with_quality_check = BookingsQualityCheckService.new.fetch
    rescue StandardError => e
      flash.now[:alert] = e.message
    end

    render :with_quality_check
  end
end
