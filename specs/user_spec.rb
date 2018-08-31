require_relative 'spec_helper'

describe "User class" do

  describe "User instantiation" do
    before do
      @user = RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334")
    end

    it "is an instance of User" do
      expect(@user).must_be_kind_of RideShare::User
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::User.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@user.trips).must_be_kind_of Array
      expect(@user.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@user).must_respond_to prop
      end

      expect(@user.id).must_be_kind_of Integer
      expect(@user.name).must_be_kind_of String
      expect(@user.phone_number).must_be_kind_of String
      expect(@user.trips).must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE, TRIP_TEST_FILE, DRIVER_TEST_FILE)

      # 1,2,1,2018-05-25 11:52:40 -0700,2018-05-25 12:25:00 -0700,10,5

      # @user = RideShare::User.new(id: 9, name: "Merl Glover III",
      #                             phone: "1-602-620-2330 x3723", trips: [])
      #
      trip = RideShare::Trip.new(id: 6, driver: @dispatcher.drivers[0], passenger: @dispatcher.passengers[0], start_time: Time.parse("2018-05-25 11:52:40 -0700"), end_time: Time.parse("2018-05-25 12:25:00 -0700"),cost: 5.0, rating: 5)

      second_trip = RideShare::Trip.new(id: 7, driver: @dispatcher.drivers[0], passenger: @dispatcher.passengers[0], start_time: Time.parse("2018-07-23 04:39:00 -0700"), end_time: Time.parse("2018-07-23 04:55:00 -0700"),cost: 3.0, rating: 5)

      @dispatcher.passengers[0].add_trip(trip)
      @dispatcher.passengers[0].add_trip(second_trip)

    end

    it "each item in array is a Trip instance" do
      @dispatcher.passengers[0].trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's user id" do
      @dispatcher.passengers[0].trips.each do |trip|
        expect(trip.passenger.id).must_equal 1
      end
    end

    it "calculates total expenditure of all rides for a given user except for in-progress trips" do

      expect(@dispatcher.passengers[0].net_expenditures).must_equal 18.00
      expect(@dispatcher.passengers[0].trips.length).must_equal 3

      @dispatcher.request_trip(1)

      expect(@dispatcher.passengers[0].trips.length).must_equal 4
      expect(@dispatcher.passengers[0].net_expenditures).must_equal 18.00
    end

    it "will return the total amount of time that user has spent on their trips" do
      expect(@dispatcher.passengers[0].total_time_spent).must_equal 4840.0
      @dispatcher.request_trip(1)
      expect(@dispatcher.passengers[0].total_time_spent).must_equal 4840.0
    end

  end
end
