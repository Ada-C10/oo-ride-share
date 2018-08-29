require_relative 'spec_helper'
require "time"

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



# (end_time - start_time) < 0
    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of user" do
      expect(@trip.passenger).must_be_kind_of RideShare::User
    end

    it "stores an instance of driver" do
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

  end

  it "raises ArgumentError if end time is before start time" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = Time.parse('2015-05-20T12:12:00+00:00')
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
      expect {RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
    end

    it "Calculates trip duration in seconds" do
        end_time = Time.parse('2015-05-20T12:14:00+00:00')
        start_time = Time.parse('2015-05-20T12:12:00+00:00')
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
        trip = RideShare::Trip.new(@trip_data)

        expect (trip.calculate_duration).must_equal 120.0
      end

end
