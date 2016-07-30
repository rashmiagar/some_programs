require 'json' 

class FreeSlot
  attr_accessor :start_time, :end_time
  
  def initialize(start_time, end_time)
    self.start_time = DateTime.parse start_time
    self.end_time = DateTime.parse end_time
  end
end

class Calendar
  
end


gcal_json = [
    {
        'start': "2015-11-01T10:00:00.00+08:00",
        'end': "2015-11-01T11:00:00.00+08:00"
    },
    {
        'start': "2015-11-01T11:00:00.00+08:00",
        'end': "2015-11-01T14:00:00.00+08:00"
    },
    {
        'start': "2015-11-01T15:00:00.00+08:00",
        'end': "2015-11-01T17:00:00.00+08:00"
    }
]

ical_json = [
    {
        'start': "2015-11-01T12:00:00.00+08:00",
        'end': "2015-11-01T13:00:00.00+08:00"
    },
    {
        'start': "2015-11-01T13:00:00.00+08:00",
        'end': "2015-11-01T14:00:00.00+08:00"
    },
    {
        'start': "2015-11-01T14:00:00.00+08:00",
        'end': "2015-11-01T15:00:00.00+08:00"
    },
    {
        'start': "2015-11-01T15:00:00.00+08:00",
        'end': "2015-11-01T16:00:00.00+08:00"
    }
]

gcal = JSON.parse gcal_json.to_json
gcal.map{|i| i.strftime('%s')}
# gcal << FreeSlot.new("2015-11-01T10:00:00.00+08:00", "2015-11-01T11:00:00.00+08:00")

ical = JSON.parse ical_json.to_json
puts ical
ical.map{|i| i.strftime('%s')}
# gcal = [[12, 13], [13, 14], [14, 15], [15, 16]]
# ical = [[10, 11], [11, 12, 13, 14], [15, 16, 17]]

union_arr = (gcal + ical).sort_by!(&:length)

result = Array.new

while(union_arr.last.length > 2)
  result << union_arr.last
  puts "<<<<<<<< #{union_arr}>>>>>>>>>>"
  union_arr.delete result.last
  
  for elem in result.last[0..result.last.size-2]
    union_arr.each{|x|
  	  if x.size== 2 && x[0]==elem
  	    union_arr.delete(x)
  	  end
    }
    puts "<<<<<<<#{union_arr}>>>>>>>>>"
    puts "<<<<<<<#{result}>>>>>>>>>>>"
  end
end

puts "<<<<<<#{union_arr + result}>>>>>>>>"
