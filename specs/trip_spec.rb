require_relative 'spec_helper'

describe "Trip class" do

  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60
      @trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
        name: "Ada",
        phone: "412-432-7640"),
        driver: RideShare::Driver.new(id: 4, vin:"77777777777777777", status: :AVAILABLE),
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

    it "raise an error if end time is before start time" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = Time.parse('2015-05-20T11:14:00+00:00')
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


  describe "calculate_trip_duration method" do
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

    it "it returns time in seconds" do
      expect @trip.calculate_trip_duration.must_equal (25 * 60)
    end
  end
end
