module AreAnagrams
  def self.are_anagrams?(string_a, string_b)
    if string_a.length != string_b.length
      false
    elsif 
      hash_string_a = Hash.new
      string_a.downcase.each_char{|chr|
        if hash_string_a.has_key?(chr)
          hash_string_a[chr] += 1
        else
          hash_string_a[chr] = 1
        end
      }

      string_b.downcase.each_char{|chr|
        if hash_string_a[chr] != nil && hash_string_a[chr] > 0
          hash_string_a[chr] -= 1
        else
          return false
        end
      }
      return true
    end
  end
end

puts AreAnagrams.are_anagrams?('orchestra', 'carthorse')