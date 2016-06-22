require_relative 'replay.rb'

# Define a .replay file.
file_path = '~/Desktop/rocket-ruby/sampleReplays/five.replay'
replay_file = File.expand_path(file_path)

# Optional, define a .json file.
data_file = '~/Desktop/rocket-ruby/sample.json'
json_file = File.expand_path(data_file)

# Create a replay object.
my_replay = Replay.new(replay_file, json_file)
my_replay.parse_data

# This creates either writes to and existing .json
# file, or creates a new one if none is given.