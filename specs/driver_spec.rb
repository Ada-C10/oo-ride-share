require_relative 'spec_helper'
require "pry"

describe "Driver class" do

    describe "Driver instantiation" do
      before do
        @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
          vin: "1C9EVBRM0YBC564DZ",
          phone: '111-111-1111',
          status: :AVAILABLE)
    end

      it "is an instance of Driver" do
        expect(@driver).must_be_kind_of RideShare::Driver
      end

      it "throws an argument error with a bad ID value" do
        expect{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
      end

      it "throws an argument error with a bad VIN value" do
        expect{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
        expect{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
      end

      it "sets driven trips to an empty array if not provided" do
        expect(@driver.driven_trips).must_be_kind_of Array
        expect(@driver.driven_trips.length).must_equal 0
      end

      it "is set up for specific attributes and data types" do
        [:id, :name, :vin, :status, :driven_trips].each do |prop|
          expect(@driver).must_respond_to prop
        end

        expect(@driver.id).must_be_kind_of Integer
        expect(@driver.name).must_be_kind_of String
        expect(@driver.vin).must_be_kind_of String
        expect(@driver.status).must_be_kind_of Symbol
      end
    end

    describe "add_driven_trip method" do
      before do
        pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
        @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
        @trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: pass, start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2018-08-09"), rating: 5)
      end

      it "throws an argument error if trip is not provided" do
        expect{ @driver.add_driven_trip(1) }.must_raise ArgumentError
      end

      it "increases the trip count by one" do
        previous = @driver.driven_trips.length
        @driver.add_driven_trip(@trip)
        expect(@driver.driven_trips.length).must_equal previous + 1
      end
    end

    describe "average_rating method" do
      before do
        @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                        vin: "1C9EVBRM0YBC564DZ")
        trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                   start_time: Time.parse("2016-08-08"),
                                   end_time: Time.parse("2016-08-08"), rating: 5)
        @driver.add_driven_trip(trip)
      end

      it "returns a float" do
        expect(@driver.average_rating).must_be_kind_of Float
      end

      it "returns a float within range of 1.0 to 5.0" do
        average = @driver.average_rating
        expect(average).must_be :>=, 1.0
        expect(average).must_be :<=, 5.0
      end

      it "returns zero if no driven trips" do
        driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                       vin: "1C9EVBRM0YBC564DZ")
        expect(driver.average_rating).must_equal 0
      end

      it "correctly calculates the average rating" do
        trip2 = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                    start_time: Time.parse("2016-08-08"),
                                    end_time: Time.parse("2016-08-09"),
                                    rating: 1)
        @driver.add_driven_trip(trip2)

        expect(@driver.average_rating).must_be_close_to (5.0 + 1.0) / 2.0, 0.01
      end


    end

    describe "total_revenue method" do
        before do
          @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                          vin: "1C9EVBRM0YBC564DZ")
          trip1 = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                     start_time: Time.parse("2016-08-08"),
                                     end_time: Time.parse("2016-08-08"), cost: 20, rating: 5)
          @driver.add_driven_trip(trip1)
        end

        it "returns zero if no driven trips" do
          driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                         vin: "1C9EVBRM0YBC564DZ")
          expect(driver.total_revenue).must_equal 0
        end

        it "correctly calculates the total_revenue" do
          trip2 = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                      start_time: Time.parse("2016-08-08"),
                                      end_time: Time.parse("2016-08-09"),
                                      cost: 10, rating: 1)
          @driver.add_driven_trip(trip2)

          expect(@driver.total_revenue).must_be_close_to 22.68
          # ((20.0 + 10.0) - 1.65) * 0.8 = 22.68
        end
      end
    end

      describe "net_expenditures method" do

        it "returns a positive number (negative earnings) that are the same as the net_ependitures as a passenger if no driven_trips" do
          @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                         vin: "1C9EVBRM0YBC564DZ")

          @user = RideShare::User.new(id: 54, name: "Rogers Bartell IV",
          phone: "1-602-620-2330 x3723", trips: [])

          trip = RideShare::Trip.new(id: 10, passenger: @user,
          start_time: Time.parse("2016-08-08"),
          end_time: Time.parse("2016-08-09"), cost: 5, rating: 5)

          @driver.add_trip(trip)
          # binding.pry

          expect(@driver.net_expenditures).must_equal 5
        end

        it "returns a negative number (positive earnings) if total_reveneue as a driver exceeds net_expenditures as passenger" do

          @user = RideShare::User.new(id: 54, name: "Rogers Bartell IV", phone: "1-602-620-2330 x3723", trips: [])

          trip = RideShare::Trip.new(id: 10, passenger: @user,
          start_time: Time.parse("2016-08-08"),
          end_time: Time.parse("2016-08-09"), cost: 5, rating: 5)

          trip2 = RideShare::Trip.new(id: 12, passenger: @user,
              start_time: Time.parse("2016-08-08"),
              end_time: Time.parse("2016-08-09"), cost: 5, rating: 5)


          @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
            vin: "1C9EVBRM0YBC564DZ")
            trip1 = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
              start_time: Time.parse("2016-08-08"),
              end_time: Time.parse("2016-08-08"), cost: 20, rating: 5)
              @driver.add_driven_trip(trip1)

          @driver.add_trip(trip)
          @driver.add_trip(trip2)



          expect(@driver.net_expenditures).must_equal -4.68
        end
end
