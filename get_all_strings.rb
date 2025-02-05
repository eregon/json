require 'json'

files = %w[
  benchmark/data/activitypub.json
  benchmark/data/canada.json
  benchmark/data/citm_catalog.json
  benchmark/data/twitter.json
]

STRINGS = []

collect_strings = -> value {
  case value
  in String then STRINGS << value
  in nil | true | false | Integer | Float then # ignore
  in Array then value.each { collect_strings[_1] }
  in Hash then value.each_pair { collect_strings[_1]; collect_strings[_2] }
  else
    raise "Unexpected value: #{value.inspect}"
  end
}

files.each { |file|
  data = JSON.load(File.read(file))
  collect_strings[data]
}

p STRINGS.size
STRINGS.each { raise _1 if _1.include? "\0" }

File.write 'strings.txt', STRINGS.join("\0")
