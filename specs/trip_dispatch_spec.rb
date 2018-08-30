require_relative 'spec_helper'
require 'time'

USER_TEST_FILE = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

describe "TripDispatcher class" do
  before do
    @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      expect(@dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      [:trips, :passengers].each do |prop|
        expect(@dispatcher).must_respond_to prop
      end
      expect(@dispatcher.trips).must_be_kind_of Array
      expect(@dispatcher.passengers).must_be_kind_of Array
      expect(@dispatcher.drivers).must_be_kind_of Array
    end
  end


  describe "find_user method" do
    it "throws an argument error for a bad ID" do
      expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a user instance" do
      expect(@dispatcher.find_passenger(2)).must_be_kind_of RideShare::User
    end
  end

  describe "find_driver method" do
    it "throws an argument error for a bad ID" do
      expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      expect(@dispatcher.find_driver(2)).must_be_kind_of RideShare::Driver
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
        expect(trip).must_be_instance_of RideShare::Trip
      end
    end
  end

  describe "User & Trip loader methods" do
    before do
      @trip = @dispatcher.trips.first
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
      passenger = @trip.passenger
      expect(passenger).must_be_instance_of RideShare::User
      expect(passenger.trips).must_include @trip
    end

    it "saves start and end time as Time objects" do
      trip_start_time = @trip.start_time
      trip_end_time = @trip.end_time
      expect(trip_start_time).must_be_instance_of Time
      expect(trip_end_time).must_be_instance_of Time
    end
  end

  describe "TripDispatcher#request_trip" do
    it "must call an available driver" do
      expect(@dispatcher.find_driver(5).status).must_equal :AVAILABLE
      expect(@dispatcher.request_trip(1).driver).must_equal @dispatcher.find_driver(8)
    end

    it "must return an instance of Trip" do
      expect(@dispatcher.request_trip(1)).must_be_instance_of RideShare::Trip
    end

    it "must return the correct trip information" do
      def change_status_to_available(driver_id)
        @dispatcher.find_driver(driver_id).status = :AVAILABLE
      end
      expect(@dispatcher.request_trip(1).id).must_equal 6
      change_status_to_available(8)
      expect(@dispatcher.request_trip(1).passenger).must_equal @dispatcher.find_passenger(1)
      change_status_to_available(8)
      expect(@dispatcher.request_trip(1).start_time).must_be_close_to Time.now, 0.01
      change_status_to_available(8)
      expect(@dispatcher.request_trip(1).end_time).must_be_nil
      change_status_to_available(8)
      expect(@dispatcher.request_trip(1).cost).must_be_nil
      change_status_to_available(8)
      expect(@dispatcher.request_trip(1).rating).must_be_nil
      change_status_to_available(8)
      expect(@dispatcher.request_trip(1).driver).must_equal @dispatcher.find_driver(8)
    end

    it "must update the driver's driven trips and status" do
      @dispatcher.request_trip(1)
      # previously driver 8 had no trips
      expect(@dispatcher.find_driver(8).driven_trips.length).must_equal 1
      expect(@dispatcher.find_driver(8).status).must_equal :UNAVAILABLE
    end

    it "must update the user's trips" do
      @dispatcher.request_trip(1)
      # previously passenger 1 had 1 trip
      expect(@dispatcher.find_passenger(1).trips.length).must_equal 2
    end

    it "must assign a driver who is not the passenger" do
      # driver 5 is the passenger
      expect(@dispatcher.request_trip(5).driver).must_equal @dispatcher.find_driver(8)
    end

    it "must raise an ArgumentError" do # possibly custom error later on
      # set all drivers to unavailable
      @dispatcher.find_driver(5).status = :UNAVAILABLE
      @dispatcher.find_driver(8).status = :UNAVAILABLE
      expect{@dispatcher.request_trip(1)}.must_raise RideShare::NoAvailableDriversError
    end

    it "selects driver with zero driven trips" do
      expect(@dispatcher.request_trip(1).driver).must_equal @dispatcher.find_driver(8)
    end

    it "chooses driver that has not driven for longest time if all drivers have driven" do
      # Add driven trip (trip) to 8 so all drivers have trips
      @dispatcher.find_driver(8).add_driven_trip(
        {
          id: 9,
          passenger: RideShare::User.new(id: 1,
                                         name: "Ada",
                                         phone: "412-432-7640"),
          start_time: start_time,
          end_time: end_time,
          cost: 23.45,
          rating: 3,
          driver: @dispatcher.find_driver(8)
        }
      )

      expect(@dispatcher.request_trip(1).driver).must_equal @dispatcher.find_driver(5)
    end
  end
end
