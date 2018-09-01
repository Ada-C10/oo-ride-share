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
      @user = RideShare::User.new(id: 9,
                                  name: "Merl Glover III",
                                  phone: "1-602-620-2330 x3723",
                                  trips: [])
      trip1 = RideShare::Trip.new(id: 8,
                                 driver: nil,
                                 passenger: @user,
                                 start_time: Time.parse("2018-07-30 22:23:55 -0700"),
                                 end_time: Time.parse("2018-07-30 22:30:55 -0700"),
                                 cost: 15,
                                 rating: 5)
      trip2 = RideShare::Trip.new(id: 8,
                                 driver: nil,
                                 passenger: @user,
                                 start_time: Time.parse("2018-08-19 20:08:00 -0700"),
                                 end_time: Time.parse("2018-08-19 20:20:14 -0700"),
                                 cost: 35,
                                 rating: 5)

      @user.add_trip(trip1)
      @user.add_trip(trip2)

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

    it 'calculates the net expenditure of all trips for the user' do
      total_cost = 0

      @user.trips.each do |trip|
        total_cost += trip.cost
      end

      expect(@user.net_expenditures).must_equal 50
    end

    it 'calculates the total time for all trips for the user' do
      total_time = 0

      @user.trips.each do |trip|
        trip_time = trip.end_time - trip.start_time
        total_time += trip_time
      end
      
      expect(@user.total_time_spent).must_equal 1154.0
    end

    it 'calculates the total time for trips excluding trips in progress' do
      trip3 = RideShare::Trip.new(id: 8,
                                 driver: nil,
                                 passenger: @user,
                                 start_time: Time.parse("2018-08-19 20:08:00 -0700"),
                                 end_time: nil,
                                 cost: nil,
                                 rating: nil)
      @user.add_trip(trip3)
      expect(@user.total_time_spent).must_equal 1154.0
    end
  end

end
