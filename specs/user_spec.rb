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
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
                                  phone: "1-602-620-2330 x3723", trips: [])

      trip = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                 start_time: Time.parse("2018-05-25 11:52:40 -0700"),
                                 end_time: Time.parse("2018-05-25 12:25:00 -0700"),cost: 5.0,
                                 rating: 5)
      second_trip = RideShare::Trip.new(id: 8, driver: nil,
                                 passenger:  @user,
                                 start_time: Time.parse("2018-07-23 04:39:00 -0700"),
                                 end_time: Time.parse("2018-07-23 04:55:00 -0700"),cost: 3.0,
                                 rating: 5)
      @user.add_trip(trip)
      @user.add_trip(second_trip)

    end

    it "each item in array is a Trip instance" do
      @user.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's user id" do
      @user.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end

    it "calculates total expenditure of all rides for a given user" do
      expect(@user.net_expenditures).must_equal 8.00
    end

    it "will return the total amount of time that user has spent on their trips" do
      expect(@user.total_time_spent).must_equal 2900.0
    end

  end
end
