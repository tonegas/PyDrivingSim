include Agent

File.open("#{$out_dir_matlab}/#{$base_name}_matlab_data_structs.m", "w") do |f|
	body = <<-EOS
	% File for interfaces
	% WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
	% Originf file: #{$objs[:origin_file]}
	% Origin CRC32: #{$crc}

	#{$objs[:in_struct].matlab_struct('in_struct')}

	#{$objs[:out_struct].matlab_struct('out_struct')}
	EOS
	f.puts body
end

puts "File #{$out_dir_matlab}/#{$base_name}_matlab_data_structs.m generated"