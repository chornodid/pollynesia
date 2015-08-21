module Pollynesia
  module Patterns
    EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

    d3 = '([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
    IP_ADDRESS = /\A(#{d3}\.){3}#{d3}\z/
  end
end
