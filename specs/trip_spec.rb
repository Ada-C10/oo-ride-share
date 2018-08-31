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
        rating: 3,
        driver: RideShare::Driver.new(id: 2, name: "michael", phone: "555-555-5555", vin: "12345678901234567", status: :AVAILABLE)}

      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of user" do
      expect(@trip.passenger).must_be_kind_of RideShare::User
    end

    it "stores an instance of driver" do
      # skip  # Unskip after wave 2
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

    it "raises an error if end time is before start time" do
    start_time = Time.parse('2015-05-20T12:14:00+00:00')
    # edited end_time so that it exists before start_time
    end_time = start_time - 25 * 60 # 25 minutes
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
  end


  describe "#calculate_trip_duration" do
    before do
      @start_time = Time.parse('2015-05-20T12:14:00+00:00')
      @end_time = Time.parse('2015-05-20T12:15:00+00:00')
      @trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        start_time: @start_time,
        end_time: @end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "Returns trip duration in seconds" do
      expect(@trip.calculate_trip_duration).must_equal 60
    end


  end
end
