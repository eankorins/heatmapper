require 'lol_api'
require 'open-uri'

def get_player_matches(name = "Clythez")
	Dir.mkdir "data/#{name}" unless File.directory?("data/#{name}")
	player = LolApi.summoner_by_name(name)
	sleep(2)
	startIndex = 0
	endIndex = 15
	call = LolApi.history_by_id(player.id, {:beginIndex => startIndex, :endIndex => endIndex})
	matches = []
	matches << call
	while not call.nil?
		sleep(2)
		puts call
		startIndex = endIndex
		endIndex = startIndex + 15
		call = LolApi.history_by_id(player.id, {:beginIndex => startIndex, :endIndex => endIndex})
		matches << call
	end

	(matches.flatten - [nil]).each do |match|
		file = "data/#{name}/#{match.match_id.to_s}.txt"
		unless File.exists?(file)
			sleep(2)
			data = LolApi.match_details(match.match_id)
			File.open(file, 'w') { |file| file.write(data.raw_match.to_s) }
		end
	end

	# details = matches.map do |m|
	# 	match = LolApi.match_details(m.match_id)
	# 	sleep(1)
	# 	match
	# end
end

LolApi.configure do |config|
	config.api_key = '1cef001f-554c-4750-85da-7404492b8b22'
end
get_player_matches