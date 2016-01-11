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

	File.open(path).each do |li|
		if (li[/": "/])
			messages << li.split(':')[0]
		end
	end

		Dir.foreach(src_dir_loc) do |item|
			Dir.foreach(src_dir_loc + "/" + item) do |file|
				if File.extname(file) == ".html" || File.extname(file) == ".htm"
					File.open(src_dir_loc + "/" + item + "/"+ file, "r") do |file_obj|
						arry << File.read(file_obj.path)
						arry.each do |file_specific_html_content|
							messages.each do |message|
								message = message.gsub(/[ \"]/, "")
								if file_specific_html_content.include?(message) && message != "title" && message != "content" && message != "header" && !used_messages.include?(message)
									used_messages << message
								end
							end
						end
					end
				end
			end
		end
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
			puts counter.to_s + ". #{y}  did not return in our search, are you sure you are using it?"
		end
end



open_and_read_File(messages_json_file, src_dir_loc) if messages_json_file && src_dir_loc

open_and_read_File() if !messages_json_file && !src_dir_loc

