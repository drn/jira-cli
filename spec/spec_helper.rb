require 'coveralls'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies.
  config.order = 'random'
end

Coveralls.wear!
