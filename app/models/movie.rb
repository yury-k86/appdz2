class Movie < ActiveRecord::Base
    def self.get_ratings
	self.find_by_sql("SELECT DISTINCT rating FROM movies").map {|c| c.rating}
    end
end

