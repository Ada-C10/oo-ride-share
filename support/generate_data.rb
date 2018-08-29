require 'csv'
require 'faker'
require 'as-duration'
require 'awesome_print'

driver_csv = CSV.open('./drivers.csv', 'w+', write_headers: true, headers: ['id', 'vehicle_id', 'status'])

passenger_csv = CSV.open('./users.csv', 'w+', write_headers: true, headers: ['id', 'name', 'phone_num'])

drivers = []
passengers = []

150.times do |id|
  name = Faker::Name.name
  phone_num = Faker::PhoneNumber.cell_phone
  id += 1

  user_hash = {'id' => id, 'name' => name, 'phone_num' => phone_num}
  driver_hash = {'id' => id}
  if rand(0..10) < 2
    driver_hash['vehicle_id'] = Faker::Vehicle.vehicle_id
    driver_hash['status'] = rand(0..10) < 3 ? :UNAVAILABLE : :AVAILABLE
    driver_csv << driver_hash
    drivers << driver_hash
  end
  passenger_csv << user_hash
  passengers << user_hash
end

trips_csv = CSV.open('./trips.csv', 'w+', write_headers: true, headers: ['id', 'driver_id', 'passenger_id', 'start_time', 'end_time', 'cost', 'rating'])
600.times do |id|
  id += 1
  driver = drivers.select {|d| d['status'] != :UNAVAILABLE }.sample['id']
  passenger = passengers.select {|pass| pass['id'] != driver}.sample['id']

  start_time = Faker::Time.between(3.months.ago, Date.today, :all)
  end_time = start_time + rand(10..150)
  cost = rand(5..30)
  rating = rand(1..5)
  trip_hash = {'id' => id, 'driver_id' => driver, 'passenger_id' => passenger,
    'start_time' => start_time, 'end_time' => end_time, 'cost' => cost,
    'rating' => rating}
  trips_csv << trip_hash
end
