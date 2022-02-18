#!/usr/bin/ruby

# Output logs without delay
STDOUT.sync = true

def convertfile(name)
  dirname = 'export_data/' + name.slice(0, name.rindex('.mbox'))

  if File.exists? dirname then
    print "Skipped: #{dirname} (directory exists)\r\n"
    return
  end

  Dir.mkdir dirname
  
  counter = 1
  
  data = ""
  lastline = ""

  begin
    File.open(name) do |file|
      eml_filename = "#{sprintf("%07d", counter)}.eml"
      print "scan: #{eml_filename}"
      eml_file = File.open(dirname + "/" + eml_filename, mode = "w")
      if !eml_file then
        print "Error: cannot open ${eml_file_name} for write"
        return
      end

      file.each_slice(1000) do |chunk|
        chunk.each do |line|
          if lastline.chomp == "" && line.start_with?('From') then
            eml_file.close
            print " => wrote\r\n"

            counter += 1
            eml_filename = "#{sprintf("%07d", counter)}.eml"
            print "scan: #{eml_filename}"
            eml_file = File.open(dirname + "/" + eml_filename, mode = "w")
            if !eml_file then
              print "Error: cannot open ${eml_file_name} for write"
              return
            end
          end
          eml_file.write(line)
          lastline = line
        end
      end
    end

    eml_file.close
    print " => wrote\r\n"
  rescue SystemCallError => e
    pp e
  rescue IOError => e
    pp e
  end
end

if !File.exists?('export_data') then
  Dir.mkdir 'export_data'
end

files = []

Dir.glob("*").each {|f|
  if f.rindex('.mbox') then
    files << f
  end
}

for i in 0..files.length do
  print "Processing #{files[i]} (#{i+1}/#{files.length} files)\r\n"
  convertfile(files[i])
end

print "Complete: All scan finished."
