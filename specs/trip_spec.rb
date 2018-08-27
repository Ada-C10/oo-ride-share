require_relative 'spec_helper'

describe "Trip class" do
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
  describe "initialize" do

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

    it "raises an ArgumentError if end time is before start time" do
      #arrange
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 # minus 25 minutes
      @trip_data[:start_time] = start_time
      @trip_data[:end_time] = end_time
      #act & #assert
      expect {
        RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
    end

  end

  describe "duration" do

    it "returns an integer" do
      expect(@trip.duration).must_be_kind_of Integer
    end

    xit "accurately subtracts time" do

    end

    # edge cases? for example, time is nil?  or raise error?

  end

end
