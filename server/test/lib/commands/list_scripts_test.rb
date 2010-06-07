ROOT_DIR = File.dirname(__FILE__)+"/../../../"
require ROOT_DIR+"/lib/commands/abstract_command"
require ROOT_DIR+"/lib/commands/list_scripts"

def pp(object, indent=0)
	i = "\t"*indent

	if(object.is_a?(Hash))

		puts "#{i}{\n"
		object.each do |k,v|
			puts "#{i}\t#{k} => #{pp(v,indent+1)},\n"
		end
		puts "#{i}}"

	elsif(object.is_a?(Array))

		puts "#{i}[\n"
		object.each do |v|
			puts "#{i}\t#{pp(v,indent+1)},\n"
		end
		puts "#{i}]"

	else
		object.to_s.inspect
	end

end

l = Commands::ListScripts.new
pp JSON.parse(l.execute)["body"]
