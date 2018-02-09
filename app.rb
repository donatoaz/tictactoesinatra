require 'sinatra'
# require 'thin'

# main app class
class MyApp < Sinatra::Application
  configure do
    # set :environment, :production
    set :bind, '0.0.0.0'
    set :port, 8080
    set :server, 'thin'
  end
end

require_relative 'routes'
require_relative 'view/board'
