guard 'bundler' do
  watch('Gemfile')
  watch(/.+\.gemspec$/)
end

group :red_green_refactor, :halt_on_fail => true do
  guard 'rspec', :cmd => 'bundle exec rspec' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^spec/spec_helper.rb$}) { 'spec' }
    watch(%r{^lib/(.+)\.rb$}) do |m|
      path_parts = File.split(m[1])
      path_parts.first.gsub!(%r{^aeries_net_api(/|$)}, '')
      path_parts.last.gsub!(/$/, '_spec.rb')
      path_parts.delete('.')
      f = File.join('spec', *path_parts)
      puts f.inspect
      f
    end
  end

  guard :rubocop, :cmd => 'bundle exec rubocop', :keep_failed => false do
    watch(/.+\.rb$/)
    watch(/.+\.gemspec$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
