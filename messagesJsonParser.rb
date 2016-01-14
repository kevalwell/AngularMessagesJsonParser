#!/usr/bin/env ruby
 
require 'rubygems'
require 'json'

#Run As: `bash` ruby messagesJsonParser.rb <messages.json_path_> <app_root_dir_path_>

messages_json_file = ARGV[0]
src_dir_loc = ARGV[1]

def open_and_read_File(path = "/Users/kalwell/Desktop/Vonage_Work/mvno/src/vg-ssu/messages.json", src_dir_loc = "/Users/kalwell/Desktop/Vonage_Work/mvno/src")
	messages = []
	used_messages = []
	arry = []
	checker = []
	counter = 0
	counter_two = 0
	puts "PROCESSING REQUEST . . . . . .  .  .  .   .    .    . PROCESSING..."
	##Begin collecting Json Keys
	#For having seperate Json message files located in folders who's root is the `path` root
	if path.split(//).last(5).join != ".json"
		Dir.foreach(path) do |data_file|
			File.open(data_file).each do |li|
				if (li[/": "/])
					messages << li.split(':')[0]
				end
			end
		end
		#Single Json file whose path is == path var passed in
	elsif path.split(//).last(5).join == ".json"
		File.open(path).each do |li|
			if (li[/": "/])
				messages << li.split(':')[0]
			end
		end
	else
		puts "Sorry, Invalid path"
	end

	puts "*" * 20 + "DONE COLLECTING JSON DATA" + "*" * 20
	##Begin Parsing Application content
		Dir.foreach(src_dir_loc) do |item|
			Dir.foreach(src_dir_loc + "/" + item) do |file|
				if file == "test"
					puts "PROCESSING TEST FOLDER FILES . . . . . . . .   .   .   .   ."
					Dir.foreach(src_dir_loc + "/" + item + "/" + file) do |filetwo|
						if File.extname(filetwo) == ".html" || File.extname(filetwo) == ".htm" || File.extname(filetwo) == ".js" || File.extname(filetwo) == ".spec"
							File.open(src_dir_loc + "/" + item + "/" + file + "/" + filetwo) do |file_obj|
								arry << File.read(file_obj.path)
							end
						end
					end
				end
				puts "PROCESSING NONTEST FILES . . . . . . . . . ."
				#Add custom file extensions here to include files in search scope
				if File.extname(file) == ".html" || File.extname(file) == ".htm" || File.extname(file) == ".js" || File.extname(file) == ".spec"
					File.open(src_dir_loc + "/" + item + "/"+ file, "r") do |file_obj|
						arry << File.read(file_obj.path)
						arry.each do |file_specific_html_content|
							messages.each do |message|
								message = message.gsub(/[ \"]/, "")
								if file_specific_html_content.include?(message) && !used_messages.include?(message)
									used_messages << message
								end
							end
						end
					end
				end
			end
		end
		puts "_____________________________________________________"
		messages.each do |message|
			message = message.gsub(/[ \"]/, "")
			checker << message
			used_messages.each do |used_message|
				if checker.include?(used_message)
					checker.delete(used_message)
					counter_two += 1
					puts counter_two.to_s + ". Used: #{used_message} "
				end
			end
		end
		puts "_____________________________________________________"
		checker.uniq.each do |y|
			counter += 1
			puts counter.to_s + ".  Potential  Unused: #{y}"
		end
end



open_and_read_File(messages_json_file, src_dir_loc) if messages_json_file && src_dir_loc

open_and_read_File() if !messages_json_file && !src_dir_loc

