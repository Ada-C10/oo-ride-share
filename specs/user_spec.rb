require_relative 'spec_helper'

describe "User class" do
  before do
    @user = RideShare::User.new(
      id: 9,
      name: "Merl Glover III",
      phone: "1-602-620-2330 x3723",
      trips: []
    )

    trip_1 = RideShare::Trip.new(
      id: 8,
      driver: nil,
      passenger: @user,
      start_time: Time.parse("2016-08-08"),
      end_time: Time.parse("2016-08-09"),
      cost: 10.25,
      rating: 5
    )

    trip_2 = RideShare::Trip.new(
      id: 9,
      driver: nil,
      passenger: @user,
      start_time: Time.parse("2016-08-09"),
      end_time: Time.parse("2016-08-10"),
      cost: 23.45,
      rating: 5
    )

    @user.add_trip(trip_1)
    @user.add_trip(trip_2)
  end

  describe "User instantiation" do
    it "is an instance of User" do
      expect(@user).must_be_kind_of RideShare::User
    end

    it "throws an argument error with a bad ID value" do
      expect{ RideShare::User.new(id: 0, name: "Smithy") }.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      user = RideShare::User.new(
        id: 9,
        name: "Merl Glover III",
        phone: "1-602-620-2330 x3723"
      )
      expect(user.trips).must_be_kind_of Array
      expect(user.trips.length).must_equal 0
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

  describe '#net_expenditures method' do
    it 'calculates the total expenditures by a User' do
      expect(@user.net_expenditures).must_equal 33.70
    end
  end

  describe '#total_time_spent method' do
    it 'calculates the total time in trips by a User' do
      expect(@user.total_time_spent).must_equal 172800.0
    end
  end
end
