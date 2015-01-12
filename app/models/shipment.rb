class Shipment < ActiveRecord::Base
  # This is coming from the documentation of activeshipping gem
  include ActiveMerchant::Shipping

  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :weight, presence: true


  def origin
    # hard coding the origin location to be my home in Seattle, technically this
    # could be the companies warehouse
    Location.new(country: "US", state: "WA", city: "Seattle", postal_code: "98112")
  end

  def destination
    # We will get the destination location from our client and parse that hash to get this
    Location.new(country: "US", state: state, city: city, postal_code: postal_code)
  end

  def packages
    # We are hard coding the standard box size as 18" L 14" W 12" H
    # We are using weight in grams and box dimensions in cms.
    Package.new(weight, [45.72, 35.56, 30.48], cylinder: false)
  end

  def get_rates_from_shipper(shipper)
    # Here we are quering the shipper api to get the rates and then sort it by
    # rates (lowest to highest)
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price)
  end

  def ups_rates
    # We are passing our access keys & password to the UPS client and then
    # calling an api
    ups = UPS.new(login: ENV['UPS_ACCESS_KEY'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_ACCESS_KEY'])
    get_rates_from_shipper(ups)
  end

  def usps_rates
    # We are passing our access keys & password to the USPS client and then
    # calling an api
    usps = USPS.new(login: ENV['USPS_USERNAME'], password: ENV['USPS_PASSWORD'])
    get_rates_from_shipper(usps)
  end
end
