require 'json'

# puts $".grep(/\.so$/)

require 'benchmark/ips'

STRINGS = File.read('strings.txt').split("\0")

test_str = 256.times.map { _1.chr(Encoding::UTF_8) }.join
expected = "\"\\u0000\\u0001\\u0002\\u0003\\u0004\\u0005\\u0006\\u0007\\b\\t\\n\\u000b\\f\\r\\u000e\\u000f\\u0010\\u0011\\u0012\\u0013\\u0014\\u0015\\u0016\\u0017\\u0018\\u0019\\u001a\\u001b\\u001c\\u001d\\u001e\\u001f !\\\"\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\u007F\u0080\u0081\u0082\u0083\u0084\u0085\u0086\u0087\u0088\u0089\u008A\u008B\u008C\u008D\u008E\u008F\u0090\u0091\u0092\u0093\u0094\u0095\u0096\u0097\u0098\u0099\u009A\u009B\u009C\u009D\u009E\u009F ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ\""

# raise unless JSON.dump(test_str) == expected

state = JSON::State.new
unless test_str.to_json(state) == expected
  puts expected
  puts test_str.to_json(state)
  raise
end

Benchmark.ips do |x|
  x.warmup = 5

  x.report ".to_json(state) for all strings" do
    result = ""
    STRINGS.each { |s| result << s.to_json(state) }
    File.write(File::NULL, result)
  end
end
