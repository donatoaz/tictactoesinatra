require 'json'
require '../pluga_developer_challenge/lib/standard.rb'

# Routes file
class MyApp < Sinatra::Application
  enable :inline_templates
  enable :sessions

  def initialize
    super
  end

  before do
    puts '[Params]'
    p params
  end

  post '/new_game' do
    session[:score] ||= 0

    @@player = { name: params[:player], type: :human, marker: 'o' }
    # create game
    @@ttt = TicTacToe::Standard.new(self, '3x3', [@@player,
                                                  { type: :computer, marker: 'x',
                                                    level: :medium }].each)
    @@ttt.run_turn_non_blocking
    @board = @@ttt.render
    haml :board
  end

  post '/move_to' do
    spot = params[:spot].to_i
    begin
      @@ttt.move_to(spot, @@player)
    rescue RuntimeError => e
      session[:error_message] = e.message
      redirect back
    end
    # let computer play
    @@ttt.run_turn_non_blocking
    # let us play again
    @@ttt.run_turn_non_blocking
    if @@ttt.game_is_over
      @winning_player = @@ttt.winning_player
      if @winning_player == 'computer'
        session[:score] = session[:score] - 1
      else
        session[:score] = session[:score] + 1
      end
      haml :game_over
    elsif @@ttt.game_is_tie
      haml :game_over
    else
      @board = @@ttt.render
      haml :board
    end
  end

  get '/' do
    haml :index
  end
end

__END__

@@ index
%form{ action: 'new_game', method: 'POST'}
  %input{ type: 'text', name: 'player[name]' }
  %br
  %input{ type: 'submit', value: 'JOIN GAME' }

@@ game_over
%h1 Game Over!
- if @winning_player
  %h2= "#{@winning_player} won!"
%h3= "Your current score is #{session[:score]}"
%br
%a{ href: '/' } New game
