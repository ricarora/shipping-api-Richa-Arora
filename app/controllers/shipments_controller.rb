class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
  end

  def create
    # format used: http://localhost:3000/shipments/new?[shipment]name=ri&[shipment]city=Seattle&[shipment]state=WA&[shipment]postal_code=98102&[shipment]weight=25
    @shipment = Shipment.new(shipment_params)
    if @shipment.save
      response = []
      response << @shipment.ups_rates.as_json(shipment_hash)
      response << usps_result_hash(@shipment.usps_rates).as_json
      render json: response
    else
      render json: {error: "Incomplete input"}
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:name, :city, :state, :postal_code, :weight)
  end

  def shipment_hash
    {only: ["service_name", "total_price", "currency", "carrier"]}
  end

  def usps_result_hash(shipments_option)
    shipments_option.collect do |shipment|
      { service_name: shipment.service_name,
        total_price: shipment.package_rates[0][:rate],
        currency: shipment.currency,
        carrier: shipment.carrier }
      end
  end
end
