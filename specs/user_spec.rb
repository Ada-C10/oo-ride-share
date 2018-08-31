require_relative 'spec_helper'
require 'pry'

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
                                 cost: 5,
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




    it "sums total amount of money user has spent on their trips" do
      # Arrange - Add two more trips to current user
      trip = RideShare::Trip.new(id: 9, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 cost: 10,
                                 rating: 5)
      @user.add_trip(trip)


      trip = RideShare::Trip.new(id: 10, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 cost: 15,
                                 rating: 5)
      @user.add_trip(trip)
      # binding.pry
      # Act - call net_expenditures method on user
      passenger_expenditure = @user.net_expenditures

      # Assert - state correct result
      expect (passenger_expenditure).must_equal 30
    end

    it "Does not include trips in progress in calculation of total amount spent on trips" do

      run_trip_dispatcher = RideShare::TripDispatcher.new()
        trip2 = RideShare::Trip.new(id: 9, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 cost: 10,
                                 rating: 5)
      @user.add_trip(trip2)

      trip3 = RideShare::Trip.new(id: 10, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 cost: 15,
                                 rating: 5)
      @user.add_trip(trip3)

      new_trip = run_trip_dispatcher.request_trip(@user.id)
      @user.add_trip(new_trip)

      passenger_expenditure = @user.net_expenditures

      expect (passenger_expenditure).must_equal 30

    end

    it "Sums the total time spent (in seconds)" do
          run_trip_dispatcher = RideShare::TripDispatcher.new()
          user_id = 94
          finding_a_passenger = run_trip_dispatcher.find_passenger(user_id)
          passenger_total_time_spent = finding_a_passenger.total_time_spent
          expect(passenger_total_time_spent).must_equal 321.0
    end

    it "Sums total time spent without including trips in progress" do

      run_trip_dispatcher = RideShare::TripDispatcher.new()
        trip2 = RideShare::Trip.new(id: 9, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 cost: 10,
                                 rating: 5)
      @user.add_trip(trip2)

      trip3 = RideShare::Trip.new(id: 10, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 cost: 15,
                                 rating: 5)
      @user.add_trip(trip3)

      new_trip = run_trip_dispatcher.request_trip(@user.id)
      @user.add_trip(new_trip)

      passenger_total_time_spent = @user.total_time_spent

      expect (passenger_total_time_spent).must_equal 259200
    end
  end
end
