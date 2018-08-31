require_relative 'spec_helper'
require 'pry'

describe "Trip class" do

  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      @trip_data = {
        #id,driver_id,passenger_id,start_time,end_time,cost,rating

        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        driver_id: 3,
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: driver
      }
      @trip = RideShare::Trip.new(@trip_data)

    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of user" do
      expect(@trip.passenger).must_be_kind_of RideShare::User
    end

    it "stores an instance of driver" do
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect {
          RideShare::Trip.new(@trip_data)
        }.must_raise ArgumentError
      end
    end

    it "Verify trip's duration in seconds" do
      expect(@trip.duration).must_equal 1500
    end

    it "raises an error when end time is before start time" do
      @trip_data[:start_time] = Time.parse('2015-05-20T12:14:00+00:00')
      @trip_data[:end_time] = Time.parse('2015-05-10T12:14:00+00:00')
      #binding.pry
      expect{
          RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
    end
  end
end
