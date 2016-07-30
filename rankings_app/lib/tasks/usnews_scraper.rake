require 'uri'
require 'net/http'
require 'nokogiri'

desc "Scrape universities data from USNews rankings"
  task :usnews_scraper do
    begin
      url = "http://colleges.usnews.rankingsandreviews.com/best-colleges/rankings/national-universities/data"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      html_doc = Nokogiri::HTML(response.body)
      
      lstpage_num = html_doc.at_css('.pager_link:nth-last-child(2)').text.to_i
    
      univ_array = []
      
      while(lstpage_num > 1)
        data = html_doc.search('table.ranking-data > tbody > tr').collect do |row|
          hash_data = {}
          name = row.search('.college_name a').text
          rank = row.search('.v_display_rank .rankscore-bronze').text.gsub("\#", "")
          tuition = row.search('.search_tuition_display').text.strip
          tot_enrl = row.search('.total_all_students').text.strip.to_i
          accep_rate = row.search('.r_c_accept_rate').text.strip
          avg_ret_rate = row.search('.r_c_avg_pct_retention').text.strip
          graduation_rate = row.search('.r_c_avg_pct_grad_6yr').text.strip

          univ_array << {'name': name, 
                       'rank': rank, 
                       'tuition_fees': tuition, 
                       'total_enrollment': tot_enrl,
                       'acceptance_rate': accep_rate,
                       'average_retention_rates': avg_ret_rate,
                       'graduation_rate': graduation_rate }
        end
      
        uri = URI.parse(url+"/page+#{lstpage_num}")
        lstpage_num -= 1
        puts uri
        http = Net::HTTP.new(uri.host, uri.port)
        response = http.request(Net::HTTP::Get.new(uri.request_uri))
        html_doc = Nokogiri::HTML(response.body)
      end

      File.open('tmp/data.json', "a+") {|file| 
        file.write(univ_array.to_json)
      }
    rescue Exception => e
      puts e
    end
  end