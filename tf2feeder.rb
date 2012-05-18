require 'sinatra'
require 'file-tail'
require 'elif'
require 'cgi'
get '/chat' do
	stream do |out|
		File.open("/srv/cs467.perryhuang.com/public_html/server12.tf2newbs.com/slog_test.log") do |log|
			log.extend(File::Tail)
			log.interval = 200
			log.backward(200)
			team = String.new
			player = String.new
			message = String.new
			flag = false
			log.tail do |line|
				if(line.include?("[CHAT]"))
					#chat_msg(line)
					line[0..13] = ""
					line[9..30] = ""
					if(line.include?("T: 2"))
						line["T: 2"] = "!@!@"
						team = "red"
					end
					if(line.include?("T: 3"))
						line["T: 3"] = "!@!@"
						team = "blue"
					end
					if(line.include?("A: 0"))
						line["A: 0"] = ""
					end
					if(line.include?("A: 1"))
						line["A: 1"] = ""
					end
					line["  Msg"] = ""
						
					time = line[0..8]
					line[0..8] = ""
					line_split = line.split " "
					line_split.each { |x|
						if(x.include?("!@!@"))
							#line_split.shift
							#line_split.shift
							break
						end
						if(!x.include?("!@!@") && player == "")
							player = x
							#x = ""
							#line_split.shift
						elsif(!x.include?("!@!@") && player != "")
							player = player + " " + x
							#line_split.shift
						#	x = ""
						end
					}
					flag = false
					line_split.each { |x|
						if(x.include?("!@!@"))
							#line_split.shift
							#line_split.shift
							flag = true
						end
						if(!x.include?("!@!@") && message == "" && flag)
							message = x
							#x = ""
							#line_split.shift
						elsif(!x.include?("!@!@") && message != "" && flag)
							message = message + " " + x
						end

					}
					if(team == "red")
						out << "<p><del>#{time} <em>#{player}</em> says #{message}</del></p>"
					#	out << "<br>"
					elsif(team == "blue")
						out << "<p><del>#{time} <strong>#{player}</strong> says #{message}</del></p>"
					#	out << "<br>"
					end
						
					#out << player
					#out << "<br>"
					#out << message
					#out << "<br>"
					#out << time
					#out << "<br>"
					#out << "#{line_split.to_s}"
					#out << "#{line}"
					#out << "<br>"
					player = ""
					flag = false
					message = ""
				elsif(line.include?("[DEATH]"))
					if(line.include?("SUICIDE"))

					elsif 
						line[0..13] = ""
						line[8..31] = ""
						line[0..10] = ""
						#out << "#{line}"
						#out << "<br>"
						if(line.include?("T: 2"))
							#line = line.gsub "T: 2", ""
							line_split = line.split " "
							attacker = String.new
							weapon = String.new
							victim = String.new
							flag = false
							#puts line
							line_split.each { |x|
								if(x.include?("(") && x.include?(")"))
									#line_split.shift
									#line_split.shift
									break
								end
								if(!x.include?("(") && !x.include?(")") && victim == "")
									victim = x
									#line_split.shift
								elsif(!x.include?("(") && !x.include?(")") && victim != "")
									victim = victim + " " + x
									#line_split.shift
								end
							}
							flag = false
							#out << "#{line_split.to_s}"
							#out << "<br>"
							line_split.each { |x|
								if(flag && x.include?("(") && x.include?(")"))
									break
								end
								if(x == "A:")
									flag = true
								elsif(!x.include?("(") && !x.include?(")") && attacker == "" && flag == true)
									attacker = x
								elsif(!x.include?("(") && !x.include?(")") && attacker != "" && flag == true)
									attacker = attacker + " " + x
								end

							}
							flag = false
							line_split = line.split " "
							line_split.each { |x|
								if(flag && x.include?("T:"))
									break
								end
								if(x == "Wep:")
									flag = true
								elsif(!x.include?("T:") && flag == true)
									weapon = x
								end
							}

							#out << "<p><del>
							out << "<p><del><em>#{attacker}</em><img src=\"killicons/#{weapon}.png\"><strong>#{victim}</strong></del></p>"	
						elsif(line.include?("T: 3"))
							#line = line.gsub "T: 2", ""
							line_split = line.split " "
							attacker = String.new
							weapon = String.new
							victim = String.new
							flag = false
							line_split.each { |x|
								if(x.include?("(") && x.include?(")"))
									#line_split.shift
									#line_split.shift
									break
								end
								if(!x.include?("(") && !x.include?(")") && victim == "")
									victim = x
									#line_split.shift
								elsif(!x.include?("(") && !x.include?(")") && victim != "")
									victim = victim + " " + x
									#line_split.shift
								end
							}
							flag = false
							#out << "#{line_split.to_s}"
							#out << "<br>"
							line_split.each { |x|
								if(flag && x.include?("(") && x.include?(")"))
									break
								end
								if(x == "A:")
									flag = true
								elsif(!x.include?("(") && !x.include?(")") && attacker == "" && flag == true)
									attacker = x
								elsif(!x.include?("(") && !x.include?(")") && attacker != "" && flag == true)
									attacker = attacker + " " + x
								end

							}

							flag = false
							line_split = line.split " "
							line_split.each { |x|
								if(flag && x.include?("T:"))
									break
								end
								if(x == "Wep:")
									flag = true
								elsif(!x.include?("T:") && flag == true)
									weapon = x
								end
							}
							#puts line
							#puts "weapon: #{weapon}"
							#out << "<p><del>
							out << "<p><del><strong>#{attacker}</strong><img src=\"killicons/#{weapon}.png\"><em>#{victim}</em></del></p>"	
						end
						
						#out << "victim is #{victim}"
						victim = ""
						weapon = ""
						#out << "<br>"
						#out << "attacker is #{attacker}"
						attacker = ""
						#out << "<br>"
					end
						

					#death_msg(line)

				end
			end
		end
	end
end

get '/prediction' do
	team_2_score = 0.0
	team_3_score = 0.0
	file = Elif.open("/srv/cs467.perryhuang.com/public_html/server12.tf2newbs.com/slog_test.log")
	file.each { |line|
		if(line.include?("Map Loading"))
			break
		end
		if(line.include?("[DEATH]") && line.include?("T: 2"))
			team_2_score = team_2_score + 1.0
		end
		if(line.include?("[DEATH]") && line.include?("T: 3"))
			team_3_score = team_3_score + 1.0
		end
	}	
	team_3_score = 2.0 * team_3_score
	total = team_2_score + team_3_score
	team_2_output = team_2_score / total * 100.0
	team_3_output = team_3_score / total * 100.0
	team_3_output = 100 - team_2_output.to_i
	#puts team_3_score.to_s
	#puts team_2_score.to_s
	"#{team_3_output.truncate}% #{team_2_output.to_i}%"
end

#get '/teams' do
#	file = Elif.open("/srv/cs467.perryhuang.com/public_html/server12.tf2newbs.com/slog_test.log")
#	#name
#	#info
#	file.each { |line|
#		if(line.include?("Map Loading"))
#			break
#		end
#		if(line.include?("[CLASSCHNG]"))
#			name = line.match('<\[CLASSCHNG.*.T:>')
#			info = line.match('/T: (2|3) Cl: [0-9]+/')
#		end
#		"#{name[0]} #{info[0]}"
#	}
#end

get '/teams' do
	file = Elif.open("/srv/cs467.perryhuang.com/public_html/server12.tf2newbs.com/slog_test.log")
	
	player_array = []
	file.each { |line|
		if(line.include?("Map Loading"))
			break
		end
		if(line.include?("[CLASSCHNG]"))
			player_name = String.new
			player_class = String.new
			player_team = String.new

			#puts line

			line_split = line.split " "
			flag = false
			line_split.each { |x|
				if(x.include?("T:"))
					#line_split.shift
					#line_split.shift
					break
				end
				if(x.include?("[CLASSCHNG]"))
					flag = true
				elsif(!x.include?("T:") && player_name == "" && flag)
					player_name = x
					#line_split.shift
				elsif(!x.include?("T:") && player_name != "" && flag)
					player_name = player_name + " " + x
					#line_split.shift
				end
			}
			flag = false
			line_split.each { |x|
				if(x.include?("Cl:"))
					#line_split.shift
					#line_split.shift
					break
				end
				if(x.include?("T:"))
					flag = true
				elsif(!x.include?("Cl:") && flag)
					player_team = x
					#line_split.shift
				end
			}
			flag = false
			line_split.each { |x|
				#if(x.include?("Cl:"))
					#line_split.shift
					#line_split.shift
				#	break
				#end
				if(x.include?("Cl:"))
					flag = true
				elsif(flag)
					player_class = x
					#line_split.shift
				end
			}
			flag = true
			player_array.each { |arr|
				if(arr[0] == player_name)
					flag = false
				end
			}
			if(flag == true)
				player_array << [player_name, player_class, player_team]
			end


		end
	}

	file.each { |line|
		if(line.include?("Map Loading"))
			break
		end
		if(line.include?("[DIS]"))
			player_array.delete_if { |arr|
				line.include?(arr[0])
			}
		end
	}


	output = String.new
	#{}"#{player_array}"
	player_array.each { |arr|
	#	puts "hi"
		output = output + "<div class=\"player\" team=\"#{arr[2]}\"><img src=\"images/#{arr[1]}.png\"><br>#{CGI::escapeHTML(arr[0])}</div>"
	}

	output
end

get '/kills' do
	stream do |out|
		File.open("/srv/cs467.perryhuang.com/public_html/server12.tf2newbs.com/slog_test.log") do |log|
			log.extend(File::Tail)
			log.interval = 100
			log.backward(50)
			log.tail do |line|
				if(line.include?("[DEATH]"))
					out << "#{line}"
					out << "<br>"
				end
			end
		end
	end
end

set :public_folder, File.dirname(__FILE__) + '/public_html'


def chat_msg(line)
	#puts "[CHAT]: " + line
	out << "#{line}"
	out << "<br>"
end

def death_msg(line)
	if(line.include?("T: 2"))
		team_1_score = team_1_score + 1
	elsif(line.include?("T: 3"))
		team_2_score = team_2_score + 1
	end
	puts "[DEATH]: " + line
end



#get '/' do
  #puts "1"
  #code = "<%= Time.now %>"
  #erb code
 # "hey this is my sinatra server"
#end