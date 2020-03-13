# Below is a list of all the bookings to a single parking space. 
# Only one car can be parked at the space at any given time. 
# This is a  method to check if there is a space available for a new booking and the cheapest cost for the booking.

require 'time'
require 'date'

@parking_space = {
  name: "Space #101",
  price: {
    hourly: 2.50,
    daily: 15.00
  },
  bookings: [
    {
      start_time: "2020-02-28 09:30:00",
      end_time: "2020-02-28 10:30:00"
    },
    {
      start_time: "2020-02-28 11:00:00",
      end_time: "2020-02-28 15:30:00"
    },
    {
      start_time: "2020-02-29 09:00:00",
      end_time: "2020-03-01 18:30:00"
    }
  ]
}



#converting time to timestamps
def to_timestamp(string)
  Time.parse(string).strftime("%s")
end

#checking availability 

def is_available?(start_time, end_time)
  start_time = to_timestamp(start_time)
  end_time = to_timestamp(end_time)

  availability = false

  @parking_space[:bookings].each do |i|
    i_start = to_timestamp(i[:start_time])
    i_end = to_timestamp(i[:end_time])

    if (start_time < i_start && end_time <= i_start) || (start_time >= i_end && end_time > i_end)
      availability = true
    else
      availability = false
      break
    end
  end

  availability
end

#checking time gap between start time and end time of the  booking

def timegap(start_time, end_time)
  time_gap = Time.parse(end_time) - Time.parse(start_time) 
  (time_gap / 3600).ceil
end

#checking days between start time and end time of the booking

def days_between(start_time, end_time)
  days_between = (Date.parse(end_time) - Date.parse(start_time)).to_i
end

#assigning charge according to hours(if hours are less than 6 ;hourly charge is applicable, if more a daily charge would give a better price)

def cost_for_hours(hours)
  if hours >= 6
    charge = @parking_space[:price][:daily]
  else
    charge = @parking_space[:price][:hourly] * hours
  end
end

#calculating hourly rates 

def hourlyrates(start_time, end_time)
  hours = timegap(start_time, end_time)
  cost_for_hours(hours)
end

#calculating total charge of parking

def calculate_price(start_time, end_time)
  days = days_between(start_time, end_time)

  if days == 0
    hourlyrates(start_time, end_time)
  else
    daily_charge = (days - 1) * @parking_space[:price][:daily]

    start_day_hours = 24 - Time.parse(start_time).hour
    start_day_charge = cost_for_hours(start_day_hours)

    end_day_hours = Time.parse(end_time).hour
    if Time.parse(end_time).min > 0
      end_day_hours += 1
    end
    end_day_charge = cost_for_hours(end_day_hours)

    daily_charge + start_day_charge + end_day_charge
  end
end

#converting number to ordinal number for priniting

def ordinal(number)
  abs_number = number.to_i.abs

    if (11..13).include?(abs_number % 100)
      "th"
    else
      case abs_number % 10
        when 1; "st"
        when 2; "nd"
        when 3; "rd"
      else    "th"
        end
      end
end

#printing out booking details 

def make_booking!(start_time, end_time)
  starthour = Time.parse(start_time).strftime("%k:%M")
  endhour = Time.parse(end_time).strftime("%k:%M")
  startmonth = Time.parse(start_time).strftime("%B" )
  endmonth = Time.parse(end_time).strftime("%B")
  startday = Time.parse(start_time).strftime("%d")
  endday = Time.parse(end_time).strftime("%d")
  
  if is_available?(start_time, end_time)
    @parking_space[:bookings].push({start_time: start_time, end_time: end_time})
    puts "Your parking has been booked for €#{calculate_price(start_time, end_time)}"
  else
    if days_between(start_time, end_time) == 0
      puts "There are no spaces available on #{startday}#{ordinal(startday)} #{startmonth} from #{starthour} to #{endhour}."
    else 
      puts "There are no spaces available from #{startday}#{ordinal(startday)}, #{startmonth} - #{endday}#{ordinal(endday)}, #{endhour}."
    end
  end

  puts ""
end


# ---------- [ TEST CASES & EXPECTED RESULTS ] ----------

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
