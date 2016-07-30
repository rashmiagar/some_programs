class HomeController < ApplicationController
  def index
  	file = File.read("tmp/data.json") 
  	@data_hash = JSON.parse(file)
  end
end