# require_relative 'user'
# # require_relative 'trip'
#
# module RideShare
#   class Driver < User
#     attr_reader :vehicle_id, :driven_trips, :status
#
#     def initialize(id, name, phone_number, trips, vehicle_id, driven_trips, status)
#
#       super(id, name, phone_number, trips)
#
#       unless vehicle_id.length = 17
#         raise ArgumentError, "Vehicle ID is invalid."
#         @vehicle_id = vehicle_id #check to make sure has 17
#         @driven_trips = driven_trips #likely an array
#         valid_status = [ :AVAILABLE, :UNAVAILABLE]
#         unless valid_status.include? status
#           raise ArgumentError, "Invalid driver status."
#           @status = status #check to make sure status is valid
#         end
#       end
#     end
