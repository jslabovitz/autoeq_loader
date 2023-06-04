require 'autoeq_loader'

# load the equalizers
equalizers = AutoEQLoader.load_equalizers('~/src/AutoEQ/results')

# find an equalizer for the FiiO FH7 headphones
eq = equalizers.find { |e| e.name =~ /fh7/i }

# show its name
puts eq.name

# run MPV with the filter
system(
  'mpv',
  "--af=#{eq.to_s}",
  'my-music-file.mp4')