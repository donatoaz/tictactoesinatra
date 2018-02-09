# doc
class MyApp < Sinatra::Application
  enable :inline_templates

  def render_board(board)
    @board = board
  end
end
__END__

@@ board
%h1 Make your move!
%form{ action: 'move_to', method: 'POST' }
  %table
    - (0..(@board.num_rows - 1)).to_a.each do |row|
      %tr
        - (0..(@board.num_cols - 1)).to_a.each do |col|
          %td{ width: '10px', height: '10px', border: '1px' }
            - if @board.available?(row, col)
              %input{ type: 'radio', name: 'spot', value: @board[row, col] }
            - else
              = @board[row, col]
  %input{ type: 'submit', value: 'make move' }
