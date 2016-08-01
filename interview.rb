require 'json' 
require 'date'
require 'active_support/time'
require 'byebug'

class Calendar
  # array of hashes [ {start: xx, end: xx}, {start: xx, end: xx}]

  attr_accessor :free_slots
  
  # input is array of json 

  def initialize(free_slot_input)
    @free_slots = JSON.parse(free_slot_input.to_json)

    # convert String datetime to an integer format for easy comparisons
    for elem in @free_slots 
      elem['start'] = (DateTime.parse elem['start']).strftime('%s').to_i
      elem['end'] = (DateTime.parse elem['end']).strftime('%s').to_i
    end
  end

  def merge(cal2)
    self.free_slots += cal2.free_slots
    self.free_slots.sort_by!{|elem| elem['end'] - elem['start']}
    self 
  end

  def length
    self.free_slots.length
  end

  def remove_overlapping_slots
    
    result = Array.new
    union_arr = self.free_slots

    while(union_arr.length > 2)
      result << union_arr.last
      union_arr.pop

      union_copy = union_arr.clone
  
      union_arr.each{|slot|
        if slot['end']-slot['start'] == 3600 && slot['start']>=result.last['start'] && slot['end']<= result.last['end']
          union_copy.delete slot
        end
      }
      union_arr = union_copy.clone
    end # end of while

    result += union_copy
    result.sort_by!{|elem| elem['start']}
    result.map!{|elem| {'start': DateTime.strptime(elem['start'].to_s, '%s')+Rational(8,24), 'end': DateTime.strptime(elem['end'].to_s, '%s')+Rational(8,24)}}

    return result
  end # end of remove_overlapping_slots 
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

gcal = Calendar.new gcal_json
ical = Calendar.new ical_json
union_calendar = gcal.merge ical
puts union_calendar.remove_overlapping_slots
