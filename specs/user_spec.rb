require_relative 'spec_helper'

describe "User class" do

  describe "User instantiation" do
    before do
      # Is this a hash that we pass in?
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
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 rating: 5)

      @user.add_trip(trip)
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
  end

  describe "net expenditures method" do
    before do
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
                                  phone: "1-602-620-2330 x3723", trips: [])
      trip1 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 cost: 10.35,
                                 rating: 5)
      trip2 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                start_time: Time.parse("2016-08-08"),
                                end_time: Time.parse("2016-08-09"),
                                cost: 20.20,
                                rating: 5)
      trip3 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                start_time: Time.parse("2016-08-08"),
                                end_time: Time.parse("2016-08-09"),
                                cost: 5.60,
                                rating: 5)
      @user.add_trip(trip1)
      @user.add_trip(trip2)
      @user.add_trip(trip3)
    end

    it "calculates the total cost of all of a user's rides" do
      expect(@user.net_expenditures).must_equal (10.35 + 20.20 + 5.60)
    end
  end

  describe "total_time_spent method" do
    before do
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
                                  phone: "1-602-620-2330 x3723", trips: [])

      trip1 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                 start_time: Time.parse("3:00"),
                                 end_time: Time.parse("4:00"),
                                 cost: 10.35,
                                 rating: 5)

      trip2 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                start_time: Time.parse("5:00"),
                                end_time: Time.parse("6:00"),
                                cost: 20.20,
                                rating: 5)

      trip3 = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                start_time: Time.parse("7:00"),
                                end_time: Time.parse("8:00"),
                                cost: 5.60,
                                rating: 5)

      @user.add_trip(trip1)
      @user.add_trip(trip2)
      @user.add_trip(trip3)
    end

    it "calculates the total amount of time spent for all trips" do
      expect(@user.total_time_spent).must_equal (@user.trips[0].duration + @user.trips[1].duration + @user.trips[2].duration)
    end
  end
end
