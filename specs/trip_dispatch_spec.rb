require_relative 'spec_helper'
require 'pry'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "is an instance of TripDispatcher" do

      dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
        TRIP_TEST_FILE, DRIVER_TEST_FILE)
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
        @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
          TRIP_TEST_FILE, DRIVER_TEST_FILE)
      end

      it "throws an argument error for a bad ID" do
        expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end

      it "finds a user instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::User
      end
    end


    # Uncomment for Wave 2
    describe "find_driver method" do
      before do
        @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
          TRIP_TEST_FILE, DRIVER_TEST_FILE)
      end

      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end

      it "finds a driver instance" do
        driver = @dispatcher.find_driver(2)
        # binding.pry
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end

    describe "Driver & Trip loader methods" do
      before do
        @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
          TRIP_TEST_FILE, DRIVER_TEST_FILE)
        end

        it "accurately loads driver information into drivers array" do
           # Unskip After Wave 2
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
            TRIP_TEST_FILE,  DRIVER_TEST_FILE)
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
            @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)

            @before_trips = @dispatcher.drivers[1].driven_trips.length

            @before_new_trip_driver = @dispatcher.drivers[1].status

            @before_passenger_trips = @dispatcher.passengers[0].trips.length

            @dispatcher.request_trip(1)

          end

          it "creates new instance of trip" do
            expect(@dispatcher.trips.last).must_be_kind_of RideShare::Trip
          end

          it "assigns first :AVAILABLE driver to the ride" do
            expect(@dispatcher.trips.last.driver.id).must_equal 5
          end

          it "assigns an available driver to the ride" do
            expect(@before_new_trip_driver).must_equal :AVAILABLE
          end

          it "should start time now" do
            expect(@dispatcher.trips.last.start_time).must_be_close_to Time.now
          end

          it "should have an endtime of nil" do
            expect(@dispatcher.trips.last.end_time).must_equal nil
          end

          it "should have a rating of nil" do
            expect(@dispatcher.trips.last.rating).must_equal nil
          end

          # check if requested trip was added to driver instance
          it "adds new instance of requested trip to driver's driven_trips array" do

            expect(@dispatcher.drivers[1].driven_trips.length).must_equal (@before_trips + 1)

            expect(@dispatcher.drivers[1].driven_trips.last.passenger.id).must_equal 1
          end

          it "adds new instance of requested trip to passengers's trips array" do

            expect(@dispatcher.passengers[0].trips.length).must_equal (@before_passenger_trips + 1)

            expect(@dispatcher.passengers[0].trips.last.driver.id).must_equal 5
          end

          it "changes drivers status to unavailble after assigning to requested trip" do

          expect(@dispatcher.drivers[1].status).must_equal :UNAVAILABLE
        end
          #check to make sure chosen driver for requested trip is unavailable

          # #driver can't drive self


        end
      end
