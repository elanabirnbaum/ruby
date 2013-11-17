require 'oauth'
require "awesome_print"
require 'json'
require 'csv'


consumer_key = ''
consumer_secret = ''
token = ''
token_secret = ''
 
api_host = 'api.yelp.com'
 
consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
access_token = OAuth::AccessToken.new(consumer, token, token_secret)

limit = 20 
path = "/v2/search?term=bars&location=brooklyn&limit=#{limit}"
bars = []

CSV.open("brooklyn.csv", "w") do |csv|
    (1..100).each do |n|
        url = path + "&offset=" + ((n*limit)-limit).to_s

        
        results = JSON.parse(access_token.get(url).body)
        
        if(results['businesses'])
            results['businesses'].each do |r| 
                begin
                    bar = [] 
                    bar << r["location"]["city"].to_s
                    bar << r["name"].to_s
                    bar << r["url"].to_s
                    bar << r["display_phone"].to_s
                    if(r["location"]["address"] )
                        bar << r["location"]["address"].join(" ")
                    else
                        bar << ""    
                    end
                    bar << r["location"]["cross_streets"].to_s
                    if(r["location"]["neighborhoods"])
                        bar << r["location"]["neighborhoods"].join(" ")
                    else
                        bar << ""
                    end
                	csv << bar
                rescue Exception => e
                    puts "Exception :::: #{e}"
                end
            end
        else
            puts "no results!!!!!!!!!!!!!!!"
        end
    end
end
