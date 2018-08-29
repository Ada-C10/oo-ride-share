require_relative 'spec_helper'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                 DRIVER_TEST_FILE)
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
    end
  end

  describe "find_user method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a user instance" do
      passenger = @dispatcher.find_passenger(2)
      expect(passenger).must_be_kind_of RideShare::User
    end
  end


  describe "find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                 DRIVER_TEST_FILE)
    end

    it "throws an argument error for a bad ID" do
      expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)

      expect(driver).must_be_kind_of RideShare::Driver
    end
  end

  describe "Driver & Trip loader methods" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                 TRIP_TEST_FILE,
                                                 DRIVER_TEST_FILE)
    end

    it "accurately loads driver information into drivers array" do
      first_driver = @dispatcher.drivers.first
      last_driver = @dispatcher.drivers.last

      expect(first_driver.name).must_equal "Driver2"
      expect(first_driver.id).must_equal 2
      expect(first_driver.status).must_equal :UNAVAILABLE
      expect(last_driver.name).must_equal "Driver8"
      expect(last_driver.id).must_equal 8
      expect(last_driver.status).must_equal :AVAILABLE
    end

    it "Connects drivers with trips" do
      trips = @dispatcher.trips

      [trips.first, trips.last].each do |trip|

        driver = trip.driver
        expect(driver).must_be_instance_of RideShare::Driver
        expect(driver.driven_trips).must_include trip
      end
    end
  end

  describe "User & Trip loader methods" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                  TRIP_TEST_FILE,
                                                  DRIVER_TEST_FILE)
    end

    it "accurately loads passenger information into passengers array" do
      first_passenger = @dispatcher.passengers.first
      last_passenger = @dispatcher.passengers.last

      expect(first_passenger.name).must_equal "User1"
      expect(first_passenger.id).must_equal 1
      expect(last_passenger.name).must_equal "Driver8"
      expect(last_passenger.id).must_equal 8
    end

    it "accurately loads trip info and associates trips with passengers" do
      trip = @dispatcher.trips.first
      passenger = trip.passenger

      expect(passenger).must_be_instance_of RideShare::User
      expect(passenger.trips).must_include trip
    end
  end

  describe "request_trip method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                  TRIP_TEST_FILE,
                                                  DRIVER_TEST_FILE)
    end

    it "returns an instance of trip" do
      trip = @dispatcher.request_trip(1)

      expect( trip ).must_be_instance_of RideShare::Trip
    end

    it "raise argumenterror if user_id is not found in passenger list" do
      expect{ @dispatcher.request_trip(99) }.must_raise ArgumentError
    end

    it "returns nil if no drivers are available" do
      @dispatcher.drivers.each do |driver|
        if driver.status == :AVAILABLE
          driver.change_status
        end
      end

      expect( @dispatcher.request_trip(1) ).must_be_nil
    end

    it 'increased the passenger trips array by 1' do
      passenger = @dispatcher.find_passenger(1)
      num_of_trips = passenger.trips.length
      @dispatcher.request_trip(1)

      expect( passenger.trips.length - num_of_trips ).must_equal 1
    end

    it 'increased the driver driven_trips array by 1' do
      driver = @dispatcher.find_driver(8)
      num_of_trips = driver.driven_trips.length
      @dispatcher.request_trip(1)

      expect( driver.driven_trips.length - num_of_trips ).must_equal 1
    end

    it 'selects a driver with an available status' do
      driver = @dispatcher.find_driver(8)
      num_of_trips = driver.driven_trips.length
      trip = @dispatcher.request_trip(1)

      expect( trip.driver.id ).must_equal 8
    end

    it 'assures that drivers cannot drive themselves' do
      trip = @dispatcher.request_trip(5)

      expect( trip.driver.id ).wont_equal 5
    end
  end

  describe 'assign driver method' do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                  TRIP_TEST_FILE,
                                                  DRIVER_TEST_FILE)
    end

    it 'returns new driver if available' do
      driver = @dispatcher.assign_driver
      expect( driver.id ).must_equal 8
    end

    it 'returns driver with the oldest most recent trip' do
      driver_5 = @dispatcher.find_driver(5)
      driver_8 = @dispatcher.find_driver(8)

      trip1 = RideShare::Trip.new(id: 8, driver: driver_5, passenger: nil,
                                  start_time: Time.parse("2016-08-05"),
                                  end_time: Time.parse("2016-08-06"),
                                  rating: 1)

      trip2 = RideShare::Trip.new(id: 8, driver: driver_8, passenger: nil,
                                  start_time: Time.parse("2016-08-09"),
                                  end_time: Time.parse("2016-08-10"),
                                  rating: 1)

      driver_5.add_driven_trip(trip1)
      driver_8.add_driven_trip(trip2)

      expect( @dispatcher.assign_driver.id ).must_equal 5

      trip3 = RideShare::Trip.new(id: 8, driver: driver_5, passenger: nil,
                                  start_time: Time.parse("2016-08-12"),
                                  end_time: Time.parse("2016-08-13"),
                                  rating: 1)

      driver_5.add_driven_trip(trip3)

      expect( @dispatcher.assign_driver.id ).must_equal 8
    end
  end
end
