require 'bindata'

# Record to store string and name information.
class StringData < BinData::Record
    endian :little
    
    int32 :len
    string :val, :read_length => :len
end

# Record to read a property's data.
class PropertyData < BinData::Record
    endian :little
    
    string_data :type
    
    int64 :data_len
    choice :data, selection: lambda{type.val} do
        int32 "IntProperty\x00"
        float "FloatProperty\x00"
        string_data "StrProperty\x00"
        string_data "NameProperty\x00"
        # Stores the array's length, data is sorted outsite the Record.
        int32 "ArrayProperty\x00"
        struct "ByteProperty\x00" do
            string_data :key_val
            string_data :byte_val
        end
        int64 "QWordProperty\x00"
        uint8 "BoolProperty\x00"
    end 
end

# Record to read a property's name.
# NOTE: This is seperate in order to test
# for the "None" terminator.
class PropertyName < BinData::Record
    endian :little
    
    string_data :name
end

# Simple way to read 32 bit integers from the file.
class DataNumber < BinData::Record
    endian :little
    
    int32 :data
end

# Record to get the map name from the file.
# The array is always of length one (1).
class MapInfo < BinData::Record
    endian :little
    
    int32 :arr_len
    array :map_data, type: :string_data, initial_length: :arr_len
end

# Record to read keyframe data.
class KeyFrame < BinData::Record
    endian :little
    
    float :time
    int32 :frame
    int32 :position
end

# Record to read debug log data (pointless data...)
# Only found in older replays.
class Debug < BinData::Record
    endian :little
    
    int32 :frame
    string_data :player
    string_data :data
end

# Record to read data for Goals and ClassIndexes
class ReaderOne < BinData::Record
    endian :little
    
    string_data :type
    int32 :frame
end

# Record to read data for Packages, Objects and Names
class ReaderTwo < BinData::Record
    endian :little
    
    string_data :package_data
end

# Record to read a property in the net cache if they exist.
class NetCacheProperty < BinData::Record
    endian :little
    
    int32 :property_index
    int32 :mapped_id
end

# Record to read the net cache.
class NetCache < BinData::Record
    endian :little
    
    int32 :class_id
    int32 :class_id_start
    int32 :class_id_end
    int32 :len
    array :data, type: :net_cache_property, initial_length: :len
end