require_relative 'spec_helper'
require 'pry'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'
UNAVAILABLE_DRIVERS_TEST_FILE = 'specs/test_data/unavailable_drivers_test.csv'

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


    # Uncomment for Wave 2
    describe "find_driver method" do
      before do
        @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)
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
          skip # Unskip after wave 2
          trips = @dispatcher.trips

          [trips.first, trips.last].each do |trip|
            driver = trip.driver
            expect(driver).must_be_instance_of RideShare::Driver
            expect(driver.trips).must_include trip
          end
        end
      end

      describe "User & Trip loader methods" do
        before do
          @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
            TRIP_TEST_FILE, DRIVER_TEST_FILE)
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

        describe "#request_trip(user_id)" do
          before do
            @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
              TRIP_TEST_FILE, DRIVER_TEST_FILE)
            end
            # let (:new_dispatcher) {
            #   dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
            #                                               TRIP_TEST_FILE, DRIVER_TEST_FILE)
            #   dispatcher.request_trip(5)
            #
            # }
            it "will return an instance of trip" do
              expect(@dispatcher.request_trip(4)).must_be_instance_of RideShare::Trip
            end

            it "will raise error if user does not exist" do
              expect {@dispatcher.request_trip(40000)}.must_raise ArgumentError
            end

            it "returns a driver who becomes UNAVAILABLE" do #when we request a driver it should become unavailable
              expect(@dispatcher.request_trip(1).driver.status).must_equal :UNAVAILABLE
            end

            it "raises argument error if all drivers are unavailable" do
              @dispatcher.request_trip(1)
              @dispatcher.request_trip(5)
              expect{@dispatcher.request_trip(8)}.must_raise ArgumentError
            end

            it "increases the trips in the driver_driven_trips array" do
              @dispatcher.request_trip(5)
              driver = @dispatcher.drivers.find { |driver| driver.id == 8 }
              before_new_trip = driver.driven_trips.length
              @dispatcher.request_trip(1)
              after_new_trip = driver.driven_trips.length
              expect(before_new_trip < after_new_trip).must_equal true
            end

            it "increases the number trips in the users list of trips array" do
              @dispatcher.request_trip(5)
              passenger = @dispatcher.passengers.find { |passenger| passenger.id ==  1}
              before_new_trip = passenger.trips.length
              @dispatcher.request_trip(1)
              after_new_trip = passenger.trips.length
              expect(before_new_trip < after_new_trip).must_equal true
              binding.pry
            end

          end

          describe "#find_driver_by_availability" do
            before do
              @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,
                TRIP_TEST_FILE, DRIVER_TEST_FILE)
              end

              it "returns a driver with  available status" do
                expect(@dispatcher.find_driver_by_availability.status).must_equal :AVAILABLE
              end

              it "raises argument error if all drivers are unavailable" do
                dispatcher_with_unavailable_drivers = RideShare::TripDispatcher.new(USER_TEST_FILE,
                  TRIP_TEST_FILE, UNAVAILABLE_DRIVERS_TEST_FILE)
                expect{dispatcher_with_unavailable_drivers.find_driver_by_availability}.must_raise ArgumentError
              end
            end

          end
