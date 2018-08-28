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

    it "raise ArgumentError if end time is before start time" do

      start_time = "2018-06-07 04:19:25 -0700"
      end_time = "2018-06-07 04:18:47 -0700"

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


      expect{RideShare::Trip.new(trip_data)}.must_raise ArgumentError
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "calculates duration of trip from hour and minutes to seconds" do

      start_time = "2018-06-07 04:20:00 -0700"
      end_time = "2018-06-07 04:50:00 -0700"

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


      expect(RideShare::Trip.new(trip_data).calculate_duration_in_sec).must_equal 1800
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
  end
end
