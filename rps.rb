require 'rack/request'
require 'rack/response'
require 'haml'
require 'thin'
require 'rack'


module PiedraPapelTijeras
	class App
		def initialize(app=nil)
			@app = app
			@content_type = :html
			@defeat = {'piedra' => 'tijeras', 'papel' => 'piedra', 'tijeras' => 'papel'}
			@throws = @defeat.keys
		end
		
		def set_env(env)
		   @env = env
		   @session = env['rack.session']
		end

		def play
		   return @session['play'].to_i if @session['play']
		   @session['play'] = 0
		end

		def play=(value)
		   @session['play'] = value
		end

		def won
		   return @session['won'].to_i if @session['won']
		   @session['won'] = 0
		end

		def won=(value)
		   @session['won'] = value
		end


		def lost
		   return @session['lost'].to_i if @session['lost']
		   @session['lost'] = 0
		end

		def lost=(value)
		   @session['lost'] = value
		end

		
		def tied
		   return @session['tied'].to_i if @session['tied']
		   @session['tied'] = 0
		end

		def tied=(value)
		   @session['tied'] = value
		end

		

		def call(env)
			set_env(env)			
			req = Rack::Request.new(env)

			req.env.keys.sort.each { |x| puts "#{x} => #{req.env[x]}" }
			
			computer_throw = @throws.sample
			player_throw = req.GET["choice"]
			
			answer = if !@throws.include?(player_throw)
				#self.play = 0
				#self.tied = 0
				#self.won = 0
				#self.lost = 0
				"Elige una de las opciones:"
			elsif player_throw == computer_throw
				self.tied = self.tied+1
				self.play = self.play+1
				"Has empatado! :|"

			elsif computer_throw == @defeat[player_throw]
				self.won = self.won+1
				self.play = self.play+1
				"Vaamos! #{player_throw} gana a #{computer_throw}!! :D"
				
			else
				self.lost = self.lost+1
				self.play = self.play+1
				"Ouu vaya! #{computer_throw} won a #{player_throw}! :("
			end

			engine = Haml::Engine.new File.open("views/index.haml").read
			res = Rack::Response.new
			res.write engine.render({},
				:answer => answer,
				:won => self.won,
				:lost => self.lost,
				:tied => self.tied,
				:play => self.play#,
				#:player => self.player,
				#:pc => self.pc)
				)
			res.finish
		end
	end
end
