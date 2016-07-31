require 'json' 
require 'date'

class FreeSlot
  attr_accessor :start_time, :end_time
  
  def initialize(start_time, end_time)
    self.start_time = (DateTime.parse start_time).strftime('%s')
    self.end_time = (DateTime.parse end_time).strftime('%s')
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
# gcal.map{|i| i.strftime('%s')}
# gcal << FreeSlot.new("2015-11-01T10:00:00.00+08:00", "2015-11-01T11:00:00.00+08:00")
for elem in gcal 
  elem['start'] = (DateTime.parse elem['start']).strftime('%s').to_i
  elem['end'] = (DateTime.parse elem['end']).strftime('%s').to_i
end


ical = JSON.parse ical_json.to_json
puts "<<<<<<<<#{ical}>>>>>>>"

for elem in ical 
  elem['start'] = (DateTime.parse elem['start']).strftime('%s').to_i
  elem['end'] = (DateTime.parse elem['end']).strftime('%s').to_i
end
puts ical
# gcal = [[12, 13], [13, 14], [14, 15], [15, 16]]
# ical = [[10, 11], [11, 12, 13, 14], [15, 16, 17]]

union_arr = (gcal + ical).sort_by!{|elem| elem['end'] - elem['start']}

puts "*********#{union_arr}*********"

result = Array.new

while(union_arr.length > 2)
  result << union_arr.last
  union_arr.pop
  # puts "<<<<<<<< #{union_arr}>>>>>>>>>>"
  
  indexes = []
  union_arr.each_with_index{|slot, i|
	  if slot['end']-slot['start'] == 3600 && slot['start']>=result.last['start'] && slot['end']<= result.last['end']
	    indexes << i
      # puts i
    end
  }
  puts indexes
  indexes.each{|i| union_arr.delete_at i}
    puts "<<<<<union<<#{union_arr}>>>>>>>>>"
    puts "<<<result<<<<#{result}>>>>>>>>>>>"
end

union_arr.map!{|elem| {'start': DateTime.strptime(elem['start'].to_s, '%s').to_s, 'end': DateTime.strptime(elem['end'].to_s, '%s')}}
result.map!{|elem| {'start': DateTime.strptime(elem['start'].to_s, '%s').to_s, 'end': DateTime.strptime(elem['end'].to_s, '%s')}}

puts "<<<<<<#{union_arr + result}>>>>>>>>"
