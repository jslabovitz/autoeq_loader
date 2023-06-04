require 'autoeq_loader'

equalizers = AutoEQLoader.load_equalizers('~/src/AutoEQ/results')

equalizers.each do |eq|
  puts eq.name
  puts eq
  puts
end