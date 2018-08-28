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

    it "raises an error if start time is greater than end time." do
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

      expect {
          RideShare::Trip.new(@trip_data)
      }.must_raise ArgumentError
    end
  end

  describe "trip_duration" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = Time.parse('2015-05-20T12:20:15+00:00')
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
    it "calculates trip duration in seconds accurately" do
      seconds_between_trips = @trip.end_time - @trip.start_time
      # p seconds_between_trips
      expect(@trip.time_duration).must_equal 375.0
      expect(@trip.time_duration).must_equal seconds_between_trips
    end

  end


#
end
