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

  describe "net expenditures" do
    before do
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
                                  phone: "1-602-620-2330 x3723", trips: [])
    end

    let (:trip1) {
      RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                          start_time: Time.parse("2016-08-08"),
                          end_time: Time.parse("2016-08-09"),
                          rating: 5, cost: 5 )
    }

    let (:trip2) {
      RideShare::Trip.new(id: 3, driver: 6, passenger: @user,
                          start_time: Time.parse("2016-08-08"),
                          end_time: Time.parse("2016-08-09"),
                          rating: 5, cost: 10 )
    }

    let (:trip3) {
      RideShare::Trip.new(id: 3, driver: 6, passenger: @user,
                          start_time: Time.parse("2016-08-08"),
                          end_time: Time.parse("2016-08-09"),
                          rating: 5, cost: 7 )
    }

    let (:trip_in_progress) {
      RideShare::Trip.new(id: 3, driver: 6, passenger: @user,
                          start_time: Time.parse("2016-08-08"),
                          end_time: nil,
                          rating: nil, cost: nil )
    }

    it 'calculates the total paid by a user' do
      @user.add_trip(trip1)
      @user.add_trip(trip2)
      @user.add_trip(trip3)

      expect(@user.net_expenditures).must_equal 22
    end

    it 'returns 0 if user has no trips' do
      expect(@user.net_expenditures).must_equal 0
    end

    it 'is able to calculate net expenditures while trip is in progress' do

      @user.add_trip(trip1)
      @user.add_trip(trip2)
      @user.add_trip(trip_in_progress)

      expect(@user.net_expenditures).must_equal 15
    end
  end

  describe 'total time spent' do
    before do
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
                                  phone: "1-602-620-2330 x3723", trips: [])
    end

    let (:trip1) {
      RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 rating: 5, cost: 5 )
    }

    let (:trip2) {
      RideShare::Trip.new(id: 3, driver: 6, passenger: @user,
                                  start_time: Time.parse("2016-08-08"),
                                  end_time: Time.parse("2016-08-09"),
                                  rating: 5, cost: 10 )
    }

    let (:trip3) {
      RideShare::Trip.new(id: 3, driver: 6, passenger: @user,
                                  start_time: Time.parse("2016-08-08"),
                                  end_time: Time.parse("2016-08-09"),
                                  rating: 5, cost: 7 )
    }

    let (:trip_in_progress) {
      RideShare::Trip.new(id: 3, driver: 6, passenger: @user,
                          start_time: Time.parse("2016-08-08"),
                          end_time: nil,
                          rating: nil, cost: nil )
    }

    it 'calculates the total time spent by user on all trips' do
      @user.add_trip(trip1)
      @user.add_trip(trip2)
      @user.add_trip(trip3)

      expect(@user.total_time_spent).must_equal 24 * 60 * 60 * 3
    end

    it 'calculates total time to 0 if user has no trips' do
      expect(@user.total_time_spent).must_equal 0
    end

    it 'can calculate total time spent while trip is in progress' do
      @user.add_trip(trip1)
      @user.add_trip(trip_in_progress)
      @user.add_trip(trip3)

      expect(@user.total_time_spent).must_equal 24 * 60 * 60 * 2
    end
  end

end
