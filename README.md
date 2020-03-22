# bookparkingslots
This app allows you to make a booking for a parking slot , keeping track for the bookings that have already been made and  returns total charge for using the slot.
You can code in your  existing bookings like below: 
start_time: "2020-02-28 09:30:00",
end_time: "2020-02-28 10:30:00"


Using the method make_booking! New bookings can be made
example: 
make_booking!("2020-02-28 10:00:00", "2020-02-28 11:00:00")
# # There are no spaces available between on 28th Feb from 10:00 - 11:00. 

make_booking!("2020-02-27 10:00:00", "2020-02-29 11:00:00")
# # There are no spaces available from 27th Feb, 10:00 - 29th Feb, 11:00.

make_booking!("2020-03-02 10:00:00", "2020-03-02 11:00:00")
# # Your parking has been booked for €2.50.

make_booking!("2020-03-02 10:00:00", "2020-03-02 11:00:00")
# # There are no spaces available between on 1st Mar from 10:00 - 11:00. 

make_booking!("2020-03-02 11:00:00", "2020-03-02 16:00:00")
# # Your parking has been booked for €12.50.

make_booking!("2020-03-02 12:00:00", "2020-03-02 13:00:00")
# # There are no spaces available between on 1st Mar from 12:00 - 13:00. 

make_booking!("2020-03-03 09:00:00", "2020-03-03 18:00:00")
# # Your parking has been booked for €15.00.

# # Daily rate is for one calendar date. Not for 24 hours.
make_booking!("2020-03-04 09:00:00", "2020-03-05 13:00:00")
# # Your parking has been booked for €30.00.

# # Cheaper to charge daily rate for one day and hourly for the other instead of two day rates.
make_booking!("2020-03-06 04:00:00", "2020-03-07 03:00:00")
# # Your parking has been booked for €22.50.



