require_relative 'spec_helper'

describe "Driver class" do

  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE)
  end

    it "is an instance of Driver" do
      expect(@driver).must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      expect{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133", status: :AVAILABLE)}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      expect{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      expect{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end



    it "sets trips to an empty array if not provided" do
      expect(@driver.driven_trips).must_be_kind_of Array
      expect(@driver.driven_trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vehicle_id, :status, :driven_trips].each do |prop|
        expect(@driver).must_respond_to prop
      end

      expect(@driver.id).must_be_kind_of Integer
      expect(@driver.name).must_be_kind_of String
      expect(@driver.vehicle_id).must_be_kind_of String
      expect(@driver.status).must_be_kind_of Symbol
    end
  end




  describe "add_driven_trip method" do
  before do
  pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
 @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678", status: :UNAVAILABLE)
   @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, date: "2016-08-08", rating: 5})
   end

  it "throws an argument error if trip is not provided" do
  expect{ @driver.add_driven_trip(1) }.must_raise ArgumentError
  end

   it "increases the trip count by one" do
  previous = @driver.driven_trips.length
  @driver.add_driven_trip(@trip)
  expect(@driver.driven_trips.length).must_equal previous + 1
  end
  end
  #
  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                      vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
      trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                 date: Time.parse("2016-08-08"), rating: 5)
      @driver.add_driven_trip(trip)
    end

    it "returns a float" do
      expect(@driver.average_rating).must_be_kind_of Float
    end

    it "returns a float within range of 0.0 to 5.0" do
      average = @driver.average_rating
      expect(average).must_be :>=, 0.0
      expect(average).must_be :<=, 5.0
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                     vin: "1C9EVBRM0YBC564DZ", status: :UNAVAILABLE)
      expect(driver.average_rating).must_equal 0
    end

    it "correctly calculates the average rating" do
      trip2 = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                  date: Time.parse("2016-08-08"), rating: 1)
      @driver.add_driven_trip(trip2)

      expect(@driver.average_rating).must_be_close_to (5.0 + 1.0) / 2.0, 0.01
    end


  end

  describe "total_revenue" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                      vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
      trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                 date: Time.parse("2016-08-08"), rating: 5, cost: 8.0)
      trip2 = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                                             date: Time.parse("2016-08-08"), rating: 1, cost: 2)
      @driver.add_driven_trip(trip)
      @driver.add_driven_trip(trip2)
    end

    it "returns total revenue" do
      expect(@driver.total_revenue).must_be_close_to 8.37

    # You add tests for the total_revenue method
  end
end

  describe "net_expenditures" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                      vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
      trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                 date: Time.parse("2016-08-08"), rating: 5, cost: 8.0)
      trip2 = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                                             date: Time.parse("2016-08-08"), rating: 1, cost: 2)
      @driver.add_driven_trip(trip)
      @driver.add_driven_trip(trip2)
      user1 = {:id=>54,:name=>"Rogers Bartell IV",:phone=>111-111-1111}
      @passenger = RideShare::User.new(user1)
      trip3 = RideShare::Trip.new(id: 8, driver: @driver, passenger: @passenger,
                                                             date: Time.parse("2016-08-08"), rating: 1, cost: 2)
      @passenger.add_trip(trip3)
    end
      it "subtracts total revenue from passenger ride cost" do
    # You add tests for the net_expenditures method
    #spent 2 - 8.37
    expect (@driver.net_expenditures).must_be_close_to (-6.37)
  end 
  end
end
