require_relative 'spec_helper'

describe "Trip class" do

  describe "initialize" do
    let (:trip_data) {
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      data = {
        id: 8,
        driver: RideShare::Driver.new(id: 2, vin: '11111111111111111', status: :UNAVAILABLE),
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
    }

    let (:trip) {
      RideShare::Trip.new(trip_data)
    }

    it "is an instance of Trip" do
      expect(trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of user" do
      expect(trip.passenger).must_be_kind_of RideShare::User
    end

    it "stores an instance of driver" do
      expect(trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        trip_data[:rating] = rating
        expect {
          RideShare::Trip.new(trip_data)
        }.must_raise ArgumentError
      end
    end

    it 'Raises an ArgumentError if the start time for a trip is later than the end time' do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 # 25 minutes earlier
      bogus_trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      expect {
        RideShare::Trip.new(bogus_trip_data)
      }.must_raise ArgumentError
    end

    it 'Calculates the trip duration in seconds' do
      expect(trip.trip_duration).must_equal 25 * 60
    end

    it 'Raises an ArgumentError if the trip duration is 0' do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time
      zero_length_trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      expect{
        RideShare::Trip.new(zero_length_trip_data)
      }.must_raise ArgumentError
    end
  end

  describe 'test trip duration if trip in progress' do
    it 'returns nil if trip is in progress' do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = nil
      in_progress_trip_data = {
        id: 8,
        driver: RideShare::Driver.new(id: 2, vin: '11111111111111111', status: :UNAVAILABLE),
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }

      my_trip = RideShare::Trip.new(in_progress_trip_data)

      expect(my_trip.trip_duration).must_be_nil
    end
  end
end
