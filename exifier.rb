require 'rubygems'
require 'exifr'
require 'fileutils'

unless ARGV.length == 2
  puts "Dude: unright number of arguments."
  puts "Usage: ruby exifier.rb <input-dir> <output-dir>\n"
  exit
end

input_dir = ARGV.first
output_dir = ARGV.last
FileUtils.mkdir(output_dir) unless File.directory?(output_dir)

Dir.glob("#{input_dir}/*").each do |name|
	begin
	  if File.file?(name) and !(File.basename(name) =~ /\.jpg$/i).nil?
	    old_name = File.expand_path(name)
	    new_name =  EXIFR::JPEG.new(old_name).date_time_original.strftime("%Y%m%d_%H%M%S") +".jpg"
	    new_name = "#{output_dir}/#{new_name}"
	    FileUtils.cp(old_name, new_name)
	    puts "Copied #{old_name} to #{new_name}"
	  end
	rescue
		puts "Unable to deal with #{name}"
	end
   # unless (File.basename(f) =~ /\.jpg$/i).nil?
   #     puts EXIFR::JPEG.new(File(f)).date_time_original
   #   end
   #  
end