require_relative 'spec_helper'

describe "Trip class" do

  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE)
      @trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: @driver

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
     # Unskip after wave 2
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

    it "raises an error if start time or end time is greater than current time " do
      start_time = Time.parse('2020-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # substracting 25 minutes
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

      expect{
        @trip = RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError

    end

    it "raises an error if start time is after end time" do

      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 # substracting 25 minutes
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

      expect{
        @trip = RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError

    end
  end

  describe "Trip#duration" do
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

    it "calculates the duration of a trip in seconds" do
      time_in_second = @trip_data[:end_time] - @trip_data[:start_time]

      expect(@trip.duration).must_equal time_in_second
    end

  end
end
