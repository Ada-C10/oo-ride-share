require_relative 'trip_dispatcher'

load_trips = RideShare::TripDispatcher.new

puts load_trips('../data/trips_test.csv'
)
