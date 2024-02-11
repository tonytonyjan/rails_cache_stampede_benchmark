# frozen_string_literal: true

task :default => %w[output/150k_histogram.png output/200k_histogram.png output/300k_histogram.png]

file('output') { mkdir _1.name }

# ex. rake output/fetch_150k_timestampes.txt
rule(%r{\Aoutput/(?:fetch|x_fetch)_\d+k_timestampes.txt\z} => ['bin/simulate', 'output']) do |t|
  matched_data = t.name.match(/(fetch|x_fetch)_(\d+)k/)
  env = {
    'FETCH_METHOD' => matched_data[1],
    'RPM' => (matched_data[2].to_i * 1000).to_s
  }
  sh(env, 'bin/simulate', { out: t.name })
end

# ex. rake output/fetch_150k.data
rule(%r{\Aoutput/(?:fetch|x_fetch)_\d+k.data\z} => [
       -> { _1.sub(/\.data\z/, '_timestampes.txt') }, 'bin/count_stampede_size'
     ]) do |t|
  sh('bin/count_stampede_size', { in: t.source, out: t.name })
end

# ex. rake output/150k_histogram.png
rule(%r{\Aoutput/\d+k_histogram.png\z} => [
       -> { _1.sub(/(\d+k)_histogram.png\z/, 'fetch_\1.data') },
       -> { _1.sub(/(\d+k)_histogram.png\z/, 'x_fetch_\1.data') },
       'lib/histogram.gnuplot'
     ]) do |t|
  rpm = File.basename(t.name).split('_').first
  sh(
    'gnuplot',
    '-e',
    "custom_title='#{rpm} RPM';fetch_path='output/fetch_#{rpm}.data'; x_fetch_path='output/x_fetch_#{rpm}.data'",
    'lib/histogram.gnuplot',
    { out: t.name }
  )
end
