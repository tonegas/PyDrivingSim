#!/usr/bin/env ruby

require 'csv'
require 'yaml'
require 'fileutils'

require_relative 'interfaces_functions'

puts "----------- csv_importer.rb ----------"

if ARGV.size != 3 then
  raise ArgumentError, "usage: #{File.basename(__FILE__)} FILE_NAME.csv BASE_NAME OUT_DIR"
end

input_file_name = ARGV[0]
base_name       = ARGV[1]
tmp_dir         = ARGV[2]

FileUtils.mkdir_p "#{tmp_dir}"
# Delete old files in temporary folder (if present)
FileUtils.rm Dir.glob("#{tmp_dir}/*")

columns = {
  :name      => {name:"Name", i:nil},
  :type      => {name:"Type", i:nil},
  :size      => {name:"Tot. num of 'Type'", i:nil},
  :bytes     => {name:"Tot. num of bytes", i:nil},
  :comment   => {name:"Comment", i:nil},
  :scenario  => {name:"Scenario (SCN) MSG", i:nil},
  :manoeuvre => {name:"Manoeuvre (MNV) MSG", i:nil}
}

objects = {
  origin_file: String.new,
  types_table: Agent::types_table(),
  in_struct:   Agent::CStruct.new(name:"input_data_str"),
  out_struct:  Agent::CStruct.new(name:"output_data_str")
}

tot_bytes  = {
  in_struct:  0,
  out_struct: 0
}

ind = 1

# Open and read file: the ".csv" file is obtained from the ".xlsx" file with "File -> Save as -> Format: "Common formats: Comma Separated Values (.csv)"
objects[:origin_file] = File.basename input_file_name
CSV.foreach("#{input_file_name}", {:encoding => "ISO-8859-1", :col_sep => ";"})  do |row|
  
  case ind
  when 1
    ind = ind + 1
    # Do nothing

  # Select the column indexes of each field
  when 2
    ind = ind + 1
    [:name, :type, :size, :bytes, :comment, :scenario, :manoeuvre].each {|k| columns[k][:i] = row.index(columns[k][:name])}

  # Create the scenario and manoeuvre messages
  else
    begin
      # Scenario message
      name    = row[columns[:name][:i]].to_s
      type    = row[columns[:type][:i]].downcase.to_sym
      size    = row[columns[:size][:i]].to_i
      bytes   = row[columns[:bytes][:i]].to_i
      comment = row[columns[:comment][:i]]

      {:scenario => :in_struct, :manoeuvre => :out_struct}.each do |k, v|
        if row[columns[k][:i]] == "x" then
          objects[v] << Agent::CStructField.new(name: name, type: type, size: size, comment: comment )
          tot_bytes[v] = tot_bytes[v] + bytes
        end
      end
    rescue => e
      # skipping unmappable row
    end
  end
end

# Write yaml file
File.open("#{tmp_dir}/#{base_name}.yml", 'w') {|f|
  f.write(objects.to_yaml)
}
puts "File #{tmp_dir}/#{base_name}.yml generated"

# Total bytes
puts "Total bytes in_struct:  #{tot_bytes[:in_struct]}" ,
     "Total bytes out_struct: #{tot_bytes[:out_struct]}"

puts "Done"
puts "--------------------------------------"
