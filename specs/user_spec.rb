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

  describe "net_expenditures method" do
    before do
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
        phone: "1-602-620-2330 x3723", trips: [])
      end

    it 'returns 0 if no trips are taken' do
      expect(@user.net_expenditures).must_equal 0
    end

    it 'returns the total costs of all trips correctly' do
      trip1 = RideShare::Trip.new(id: 8, passenger: @user,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"), cost: 17,
        rating: 5)

      trip2 = RideShare::Trip.new(id: 8, passenger: @user,
          start_time: Time.parse("2016-08-08"),
          end_time: Time.parse("2016-08-09"), cost: 20,
          rating: 5)

      @user.add_trip(trip1)
      @user.add_trip(trip2)

      expect(@user.net_expenditures).must_equal 37
    end

    it 'returns the net expenditure for only completed trips' do
      trip1 = RideShare::Trip.new(id: 8, passenger: @user,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"), cost: 17,
        rating: 5)

      trip2 = RideShare::Trip.new(id: 8, passenger: @user,
          start_time: Time.now,
          end_time: nil, cost: nil,
          rating: nil)

      @user.add_trip(trip1)
      @user.add_trip(trip2)

      expect(@user.net_expenditures).must_equal 17

    end

  end

  describe "total_time_spent method" do
    before do
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
        phone: "1-602-620-2330 x3723", trips: [])
      end

    it 'returns 0 if no trips are taken' do
      expect(@user.total_time_spent).must_equal 0
    end

    it 'returns the total time of all trips correctly' do
      trip1 = RideShare::Trip.new(id: 8, passenger: @user,
        start_time: Time.parse("2016-08-08 11:00:00"),
        end_time: Time.parse("2016-08-08 11:30:00"), cost: 17,
        rating: 5)

      trip2 = RideShare::Trip.new(id: 8, passenger: @user,
          start_time: Time.parse("2016-08-09 11:00:00"),
          end_time: Time.parse("2016-08-09 11:30:00"), cost: 20,
          rating: 5)

      @user.add_trip(trip1)
      @user.add_trip(trip2)

      expect(@user.total_time_spent).must_equal 60
    end

    it 'returns the total time of only completed trips' do
      trip1 = RideShare::Trip.new(id: 8, passenger: @user,
        start_time: Time.parse("2016-08-08 11:00:00"),
        end_time: Time.parse("2016-08-08 11:30:00"), cost: 17,
        rating: 5)

      trip2 = RideShare::Trip.new(id: 8, passenger: @user,
          start_time: Time.now,
          end_time: nil, cost: nil,
          rating: nil)

      @user.add_trip(trip1)
      @user.add_trip(trip2)

      expect(@user.total_time_spent).must_equal 30
    end
  end

end
