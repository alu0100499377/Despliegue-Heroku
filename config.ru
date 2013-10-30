require './rps.rb'

use Rack::Static, :urls => ['/public']
use Rack::ShowExceptions
use Rack::Lint
use Rack::Session::Cookie,
	{:key => 'rack.session',
	:secret => 'cookie'}

run PiedraPapelTijeras::App.new
