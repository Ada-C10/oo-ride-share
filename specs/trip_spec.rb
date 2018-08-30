require_relative 'spec_helper'

describe "Trip class" do
  before do
    @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
      vin: "1C9EVBRM0YBC564DZ",
      phone: '111-111-1111',
      status: :AVAILABLE)
    @pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
    @inprogress_trip = RideShare::Trip.new({id: 5, driver: @driver, passenger: @pass, start_time: "2016-08-08", end_time: nil, cost: nil, rating: nil})

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
      driver: @driver
    }

    @trip = RideShare::Trip.new(@trip_data)
  end

  describe "initialize" do
    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of user" do
      expect(@trip.passenger).must_be_kind_of RideShare::User
    end

    it "stores an instance of driver" do
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    # Tests start here
    it "has trips with end times after their start times" do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                  TRIP_TEST_FILE,
                                                  DRIVER_TEST_FILE)

       # Loop through trips
       @dispatcher.trips.each do |trip|
         # Check if end time is greater than start time
         expect(trip.end_time > trip.start_time).must_equal true
       end
    end

    it "raises an ArgumentError if start time is after end time" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = Time.parse('2014-05-20T12:14:00+00:00')
      @bad_trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      expect{RideShare::Trip.new(@bad_trip_data)}.must_raise ArgumentError
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect {
          RideShare::Trip.new(@trip_data)
        }.must_raise ArgumentError
      end
    end
  end

  describe 'Trip.duration' do
    it 'returns duration of trip in seconds' do
      expect(@trip.duration).must_equal (25 * 60)
    end

    it 'correctly calculates the duration in seconds' do
      expect(@trip.duration).must_equal(@trip.end_time - @trip.start_time)
    end

    it 'raises an InProgressTripError if called on an in-progress trip' do
      expect{@inprogress_trip.duration}.must_raise RideShare::InProgressTripError
    end
  end
end
