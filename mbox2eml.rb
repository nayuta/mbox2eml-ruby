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
      print "scan: #{sprintf("%04d", counter)}.eml"
      file.each_line do |line|
        if lastline.chomp == "" && line.index('From') == 0 then
          if data != "" then
            File.write(dirname + "/" + sprintf("%04d", counter) + ".eml", data)
            print " => wrote\r\n"
            data = line
            counter += 1
            print "scan: #{sprintf("%04d", counter)}.eml"
          end
        else
          data += "#{line}"
        end
        lastline = line
      end
    end
  rescue SystemCallError => e
    pp e
  rescue IOError => e
    pp e
  end
  
  if data != "" then
    File.write(dirname + "/" + sprintf("%04d", counter) + ".eml", data)
    print " => wrote\r\n"
  else
    print " => last mail not found\r\n"
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
