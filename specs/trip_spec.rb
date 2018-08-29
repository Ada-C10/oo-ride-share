require_relative 'spec_helper'

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
          rating: 3
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
          skip# Unskip after wave 2
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

      it "raises error if end time is before start time" do

        test_trip_input = {:id => 1234, :passenger => "George Foreman", :start_time => "2018-05-25 12:25:00 -0700", :end_time => "2018-05-25 11:52:40 -0700", :cost => 100, :rating => 3}

        expect{ RideShare::Trip.new(test_trip_input) }.must_raise ArgumentError
      end

      it "calculates ride duration in seconds" do
        test_trip_input = {:id => 1234, :passenger => "George Foreman", :end_time => Time.parse("2018-05-25 12:25:00 -0700"), :start_time => Time.parse("2018-05-25 11:52:40 -0700"), :cost => 100, :rating => 3}
        test_ride = RideShare::Trip.new(test_trip_input)

        expect(test_ride.duration).must_equal(test_ride.end_time - test_ride.start_time)
      end

    end
  end
