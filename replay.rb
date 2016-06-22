require 'json'
require_relative 'records.rb'
require_relative 'property.rb'

class Replay
    
    attr_reader :replay, :json_file, :header_data
    
    def initialize(replay, json_file)
        @replay = replay
        @json_file = json_file
        @header_data = nil
    end
    
    def parse_data()
        @header_data = Hash.new
        meta_data = []

        File.open(@replay){|file|
            # Size of the header section in bytes.
            header_size = DataNumber.new.read(file)

            # Fourty bytes of irrelevent data.
            file.read(40)
            
            # Read the data for the header.
            read_header(file)
            
            # Size of the remaining part of the file in bytes.
            remaining_size = DataNumber.new.read(file)

            # Total size of the file in bytes.
            file_size = header_size.data + remaining_size.data + 16

            # Not sure what these four bytes represent yet.
            file.read(4)

            # Read map info (specifically name), also found in header data.
            map = MapInfo.new.read(file)
            map_name = map.map_data[0].val[0...-1]

            # Read data for the keyframe objects.
            read_objects(file, [KeyFrame])

            # Net stream data, not important as of now.
            len = DataNumber.new.read(file)
            file.read(len.data)

            # Read data for the remaining objects.
            # You can see what each reader reads above their respective Records.
            read_objects(file, [Debug, ReaderOne, ReaderTwo, ReaderTwo, ReaderTwo, ReaderOne])

            # Read data for the net cache.
            cache = NetCache.new.read(file)

            puts "All data read successfully." 
        }
        @json_file == nil ? make_json : write_to_json
    end

    def read_header(file)
        keep_reading = true
        while keep_reading do
            property = Property.new(file)
            if property.name != "None"
                @header_data[property.name] = property.data
            else
                keep_reading = false 
            end
        end
    end

    # Reads data for objects.length amount of objects.
    def read_objects(file, objects)
        objects.each{|data_type|
            num = DataNumber.new.read(file).data

            # use i to indentify the type of object.
            num.times{|i|
                 obj = data_type.new.read(file)
            }
        }
    end
    
    def write_to_json
        File.open(@json_file, "w"){|file|
            file.write(JSON.pretty_generate(@header_data))
        }
        puts "Data successfully written to #{File.basename(@json_file)}."
    end

    def make_json
        out_file = File.new("data.json", "w")
        out_file.write(JSON.pretty_generate(@header_data))
        out_file.close
        puts "A data.json file containing the header data has been generated."
    end
end