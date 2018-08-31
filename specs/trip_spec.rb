require_relative 'spec_helper'
require 'pry'

describe "Trip class" do

  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: RideShare::Driver.new(id: 4,
                                      name: "Josh",
                                      phone: "206-555-5555",
                                      vin: "11111111111111111",
                                      status: :AVAILABLE)
        # Added driver to give "stores an instance of driver" (see test below) data to test.
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
      # skip  # Unskip after wave 2
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

    it "raises an error if end time is before start time" do
      @trip_data[:end_time] = Time.parse('2015-05-20T12:14:00+00:00')
      @trip_data[:start_time] = Time.parse('2017-05-20T12:14:00+00:00')

      expect {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
    end

    it "Calculates the duration of the trip in seconds" do
      @trip_data[:end_time] = Time.parse('2015-05-20T12:15:00+00:00')
      @trip_data[:start_time] = Time.parse('2015-05-20T12:14:00+00:00')

      test_trip = RideShare::Trip.new(@trip_data)
      expect(test_trip.duration).must_equal 60.00
    end
  end


  describe "request_trip does not affect trip class calculations" do
    before do
      dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                DRIVER_TEST_FILE)

      @trip = dispatcher.request_trip(1)
    end

    it "does not raise an error for rating value of nil" do

      expect (@trip.rating).wont_be_kind_of ArgumentError
    end

    it "does not calculate the duration of the trip in seconds" do
      expect (@trip.duration).must_equal "In Progress"
    end
  end
end
