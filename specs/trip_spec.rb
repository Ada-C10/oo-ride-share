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
        skip  # Unskip after wave 2
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


      it "it raises an ArgumentError if the end time is before the start time " do
        # Arrange
        # make a start time that is after an end time
        # and put those in @trip_data

        # Act
        # Make a new trip with the bad times


        end_time = "2015-05-20T12:14:00+00:00"
        start_time = "2015-05-20T12:16:00+00:00"
        trip_data = {
          id: 8,
          passenger: RideShare::User.new(id: 1,
            name: "Ada",
            phone: "412-432-7640"),
            start_time: Time.parse(start_time),
            end_time: Time.parse(end_time),
            cost: 23.45,
            rating: 3
          }


        expect {
          # binding.pry
          RideShare::Trip.new(trip_data)

          # Assert
        }.must_raise ArgumentError

      end

      it "calculates the duration of the trip in seconds" do
        end_time = "2018-08-29T09:18:26-07:00"
        start_time = "2018-08-29T08:53:26-07:00"
        trip_data = {
          id: 8,
          passenger: RideShare::User.new(id: 1,
            name: "Ada",
            phone: "412-432-7640"),
            start_time: Time.parse(start_time),
            end_time: Time.parse(end_time),
            cost: 23.45,
            rating: 3
          }


          # create bunny as an instance of a trip.

        bunny = RideShare::Trip.new(trip_data)
        # calls the method duration
        expect bunny.duration.must_equal 1500.0
      end

    end
  end
