require_relative 'spec_helper'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

describe "TripDispatcher class" do
  before do
    @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                TRIP_TEST_FILE,
                                                DRIVER_TEST_FILE)
  end
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      expect(@dispatcher).must_be_kind_of RideShare::TripDispatcher
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
    it "throws an argument error for a bad ID" do
      expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a user instance" do
      passenger = @dispatcher.find_passenger(2)
      expect(passenger).must_be_kind_of RideShare::User
    end
  end

  describe "find_driver method" do
    it "throws an argument error for a bad ID" do
      expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      expect(driver).must_be_kind_of RideShare::Driver
    end
  end

  describe "Driver & Trip loader methods" do
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

  describe "Request trip method" do
    it "returns an instance of trip" do
      new_trip = @dispatcher.request_trip(3)

      expect(new_trip).must_be_kind_of RideShare::Trip
    end

    it "updates the passenger trip list" do
      current_passenger = @dispatcher.find_passenger(3)
      current_number_of_trips = current_passenger.trips.length
      @dispatcher.request_trip(3)

      expect(current_passenger.trips.length).must_equal (current_number_of_trips + 1)
    end

    it "updates the driver trip list" do
      current_driver = @dispatcher.find_driver(5)
      current_number_of_trips = current_driver.driven_trips.length
      @dispatcher.request_trip(3)

      expect(current_driver.driven_trips.length).must_equal (current_number_of_trips + 1)
    end

    it "ensures that driver assigned is available" do
      driver = @dispatcher.check_driver_availability_and_assign(3)

      expect(driver.status).must_equal :AVAILABLE
    end

    it "raises an ArgumentError if there are no available drivers" do
      @dispatcher.request_trip(6)
      @dispatcher.request_trip(3)

      expect{@dispatcher.request_trip(1)}.must_raise ArgumentError
    end

    it "checks that drivers are not driving themselves" do
      new_trip = @dispatcher.request_trip(5)
      passenger = new_trip.passenger.id
      driver = new_trip.driver.id

      expect(passenger).wont_equal driver
    end

    it "will ensure that the driver who is selected has no trips" do
      dispatcher_2 = RideShare::TripDispatcher.new(USER_TEST_FILE,
                                                  'specs/test_data/trips_dispatcher_test.csv',
                                                  'specs/test_data/driver_test_new.csv')
      new_trip = dispatcher2.request_trip(3)
      driver = new_trip.driver

      expect(driver.trips.length).must_equal 1
      expect(driver.id).must_equal 8
    end

    it "will ensure that the driver selected has the oldest trip given all drivers have trips" do

    end

  end

  describe "In Progress Trips" do
    it "will calculate total money spent even with an in progress trip" do
      new_trip = @dispatcher.request_trip(3)
      total_spent = new_trip.passenger.net_expenditures

      expect(total_spent).must_equal 7
    end

    it "will calculate the average hourly revenue for a driver with an in progress trip" do
      new_trip = @dispatcher.request_trip(3)

      total_seconds_driven = 0
      new_trip.driver.driven_trips.each do |trip|
        if trip.end_time != nil
          total_seconds_driven += trip.end_time - trip.start_time
        end
      end

      total_hours_driven = (total_seconds_driven.to_f / 3600).round(2)
      average_hourly_rate = (new_trip.driver.total_revenue / total_hours_driven).round(2)

      expect(average_hourly_rate).must_equal 31.28
    end
  end
end
