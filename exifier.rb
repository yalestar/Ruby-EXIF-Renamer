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
date_format = "%Y%m%d_%H%M%S"
idx = 1
ok =0
same = 0
sep = "-".ljust(80, '-')
not_jpg_files = Array.new
files_in_error = Array.new

FileUtils.mkdir(output_dir) unless File.directory?(output_dir)

Dir.glob("#{input_dir}/*").each do |name|
	begin
	  if File.file?(name) and !(File.basename(name) =~ /\.jpg$/i).nil?
	    old_name = File.expand_path(name)
      # @TODO : Add test on EXIFR::JPEG.date_time existence or date_time_original ?
      # @BUG : On some old photos date_time isn't recognized ? Is this old EXIF format ?
	    new_name =  EXIFR::JPEG.new(old_name).date_time.strftime(date_format) 
	    new_name = "#{output_dir}/#{new_name}"
	    # If this file exists, then add a suffix number.
	    i = 1
	    suffix = ""
	    while File.file?(new_name + suffix + ".jpg") do 
	      suffix = "-" + i.to_s 
	      puts "#{output_dir}/#{new_name} already exists... Adding a little suffix '" + suffix + "'"
	      i = i + 1
	    end
	    if suffix != "" 
	      same = same + 1 
	    end
	    new_name << suffix << ".jpg"
	    FileUtils.cp(old_name, new_name)
	    puts "Copied #{old_name} to #{new_name}"
	    ok = ok + 1
	   else # There are others files than jpg, it have to be noticed !
	     not_jpg_files << name
     end
	rescue => e
		puts "Unable to deal with #{name}\n#{e.message}"
		# Putting the file in error in an array for futher usage
		files_in_error << name
	end
   # unless (File.basename(f) =~ /\.jpg$/i).nil?
   #     puts EXIFR::JPEG.new(File(f)).date_time_original
   #   end
   #  
end
#
# Smart Reporting of what was really done
#
puts sep
puts "Input dir is  : '#{input_dir}'"
puts "Output dir is : '#{output_dir}'"
puts sep
puts (ok + files_in_error.count).to_s + " files to rename."
puts sep
puts "" + ok.to_s + " files were correctly renamed ("+ same.to_s + " were suffixed)."
puts sep
puts "" + files_in_error.count.to_s + " files unchanged due to an error (see details after)."
if files_in_error.count > 0
  files_in_error.each do |n|
    puts "  " + n
  end
end
puts sep
if not_jpg_files.count > 0 
  puts "" + not_jpg_files.count.to_s + " files are not jpg files."
  not_jpg_files.each do |n|
    puts "  " + n
  end
end
