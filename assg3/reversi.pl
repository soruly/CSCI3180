# CSCI3180 Principles of Programming Languages
# -- Declaration ---
# I declare that the assignment here submitted 
# is original except for source material explicitly
# acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in 
# academic work, and of the disciplinary guidelines
# and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/
# Assignment 3
# Name: 
# Student ID: 
# Email Addr: 
#
#use warnings;
#use strict;
package Reversi;
sub new {
  my $class = shift;
  my $this = {
    board => shift,
    black => shift,
    white => shift,
    turn => shift,
    validMoves => shift,
  };
  $this->{validMoves} = ();
  $this->{board} = [
    [".",".",".",".",".",".",".","."],
    [".",".",".",".",".",".",".","."],
    [".",".",".",".",".",".",".","."],
    [".",".",".","O","X",".",".","."],
    [".",".",".","X","O",".",".","."],
    [".",".",".",".",".",".",".","."],
    [".",".",".",".",".",".",".","."],
    [".",".",".",".",".",".",".","."]
  ];
  $this->{black} = {"symbol" => "X"};
  $this->{white} = {"symbol" => "O"};
  print "First player is (1) Computer or (2) Human? ";
  chomp($input = <>);
  if ($input == "1") {
    bless($this->{black},"Computer");
    print "Player X is Computer\n";  
  }
  else{
    bless($this->{black},"Human");
    print "Player X is Human\n";
  }
  $this->{black}->new;

  print "Second player is (1) Computer or (2) Human? ";
  chomp($input = <>);
  if ($input == "1") {
    bless($this->{white},"Computer");
    print "Player O is Computer\n";  
  }
  else{
    bless($this->{white},"Human");
    print "Player O is Human\n";
  }
  $this->{white}->new;

  $this->{turn} = $this->{black};
  bless $this;
}
sub startGame {
  my $this = shift;
  my $playersPassed = 0;
  while (1) {
    $this->printBoard;
    $this->generateAllValidMoves;
    my @move = $this->{turn}->nextMove($this->{validMoves});
    if($this->validate($move[0],$move[1])){
      $playersPassed = 0;
      $this->makeMove($move[0],$move[1],0);
      print "Player $this->{turn}->{symbol} places to row $move[0], col $move[1]\n";
    }
    else{
      print "Row $move[0], col $move[1] is invalid! Player $this->{turn}->{symbol} passed!\n";
      $playersPassed++;
    }

    my $space = 0;
    for (my $i = 0; $i <= 7; $i++) { #check if the board is full
      for (my $j = 0; $j <= 7; $j++) {
        if($this->{board}[$i][$j] eq "."){
          $space++;
        }
      }
    }

    if($playersPassed >= 2 || $space == 0){ #either both has passed or board is full
      $this->printBoard(1);
      last; #end game
    }
    else{ #continue the game
      if($this->{turn} == $this->{black}){
        $this->{turn} = $this->{white};
      }
      else{
        $this->{turn} = $this->{black};
      }
    }
  }
}
sub printBoard {
  my $this = shift;
  my $endgame = shift; #equals to 1 if end game
  my $black = 0;
  my $white = 0;
  print "  0 1 2 3 4 5 6 7\n";
  for (my $i = 0; $i <= 7; $i++) {
    print "$i ";
    for (my $j = 0; $j <= 7; $j++) {
      print "$this->{board}[$i][$j] ";
      if($this->{board}[$i][$j] eq "X"){
        $black++;
      }
      if($this->{board}[$i][$j] eq "O"){
        $white++;
      }
    }
    print "\n";
  }
  print "Player X: $black\n";
  print "Player O: $white\n";

  if($endgame){ #also print the final result if endgame
    if ($black > $white) {
      print "Player X wins!\n";
    }
    elsif($white > $black){
      print "Player O wins!\n";
    }
    else{
      print "Draw game!\n";
    }
    
  }
}
sub generateAllValidMoves{
  my $this = shift;
  my $symbol = $this->{turn}->{symbol};
  @{$this->{validMoves}} = ();
  for (my $i = 0; $i <= 7; $i++) {
    for (my $j = 0; $j <= 7; $j++) {
      if($this->{board}[$i][$j] eq "."){
        if($this->makeMove($i,$j,1) > 0){
          #print "Valid Moves: $i,$j\n";
          push @{$this->{validMoves}}, [$i,$j];
        }
      }
    }
  }
}
sub getAllValidMoves{
  my $this = shift;
  return @{$this->{validMoves}};
}
sub makeMove{ #this is only called after validate
  my $this = shift;
  my $row = shift;
  my $col = shift;
  my $dryRun = shift; # 0 or 1, 1 means do not touch the board, just return the count
  my $symbol = $this->{turn}->{symbol};

  if($dryRun != 1){
    $this->{board}[$row][$col] = $this->{turn}->{symbol}; #actually make the move
  }
  #scan in 8 directions
  my $flipped = 0;
  my $i = $row;
  my $j = $col;
  my @stack = ();

  # horizontal, to the right
  $i = $row;
  $j = $col;
  @stack = ();
  while ($j < 7) {
    $j++;
    if($this->{board}[$i][$j] eq "."){ #it must be adjcent to some symbols
      last; #break and drop the stack
    }
    if($this->{board}[$i][$j] ne "." and $this->{board}[$i][$j] ne $symbol){ #occupied by opponent
      push @stack, [$i,$j]; #mark opponents position in case we have to flip
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack == 0){ #cannot eclose any opponent
      last; #break at the nearest symbol
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack > 0){ #enclosed some opponent
      foreach $position (@stack){ #take out all the stored symbol
        #print "@{$position}[0],@{$position}[1]\n";
        if($dryRun != 1){
          $this->{board}[@{$position}[0]][@{$position}[1]] = $this->{turn}->{symbol}; #actually flip the symbol
        }
        $flipped++;
      }
      last; #break at the nearest symbol
    }
  }

  # horizontal, to the left
  $i = $row;
  $j = $col;
  @stack = ();
  while ($j > 0) {
    $j--;
    if($this->{board}[$i][$j] eq "."){ #it must be adjcent to some symbols
      last; #break and drop the stack
    }
    if($this->{board}[$i][$j] ne "." and $this->{board}[$i][$j] ne $symbol){ #occupied by opponent
      push @stack, [$i,$j]; #mark opponents position in case we have to flip
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack == 0){ #cannot eclose any opponent
      last; #break at the nearest symbol
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack > 0){ #enclosed some opponent
      foreach $position (@stack){ #take out all the stored symbol
        #print "@{$position}[0],@{$position}[1]\n";
        if($dryRun != 1){
          $this->{board}[@{$position}[0]][@{$position}[1]] = $this->{turn}->{symbol}; #actually flip the symbol
        }
        $flipped++;
      }
      last; #break at the nearest symbol
    }
  }

  # vertical, to the top
  $i = $row;
  $j = $col;
  @stack = ();
  while ($i > 0) {
    $i--;
    if($this->{board}[$i][$j] eq "."){ #it must be adjcent to some symbols
      last; #break and drop the stack
    }
    if($this->{board}[$i][$j] ne "." and $this->{board}[$i][$j] ne $symbol){ #occupied by opponent
      push @stack, [$i,$j]; #mark opponents position in case we have to flip
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack == 0){ #cannot eclose any opponent
      last; #break at the nearest symbol
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack > 0){ #enclosed some opponent
      foreach $position (@stack){ #take out all the stored symbol
        #print "@{$position}[0],@{$position}[1]\n";
        if($dryRun != 1){
          $this->{board}[@{$position}[0]][@{$position}[1]] = $this->{turn}->{symbol}; #actually flip the symbol
        }
        $flipped++;
      }
      last; #break at the nearest symbol
    }
  }

  # vertical, to the bottom
  $i = $row;
  $j = $col;
  @stack = ();
  while ($i < 7) {
    $i++;
    if($this->{board}[$i][$j] eq "."){ #it must be adjcent to some symbols
      last; #break and drop the stack
    }
    if($this->{board}[$i][$j] ne "." and $this->{board}[$i][$j] ne $symbol){ #occupied by opponent
      push @stack, [$i,$j]; #mark opponents position in case we have to flip
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack == 0){ #cannot eclose any opponent
      last; #break at the nearest symbol
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack > 0){ #enclosed some opponent
      foreach $position (@stack){ #take out all the stored symbol
        #print "@{$position}[0],@{$position}[1]\n";
        if($dryRun != 1){
          $this->{board}[@{$position}[0]][@{$position}[1]] = $this->{turn}->{symbol}; #actually flip the symbol
        }
        $flipped++;
      }
      last; #break at the nearest symbol
    }
  }


  # diagonal, top-left to bottom-right
  $i = $row;
  $j = $col;
  @stack = ();
  while ($i < 7 and $j < 7) {
    $i++;
    $j++;
    if($this->{board}[$i][$j] eq "."){ #it must be adjcent to some symbols
      last; #break and drop the stack
    }
    if($this->{board}[$i][$j] ne "." and $this->{board}[$i][$j] ne $symbol){ #occupied by opponent
      push @stack, [$i,$j]; #mark opponents position in case we have to flip
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack == 0){ #cannot eclose any opponent
      last; #break at the nearest symbol
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack > 0){ #enclosed some opponent
      foreach $position (@stack){ #take out all the stored symbol
        #print "@{$position}[0],@{$position}[1]\n";
        if($dryRun != 1){
          $this->{board}[@{$position}[0]][@{$position}[1]] = $this->{turn}->{symbol}; #actually flip the symbol
        }
        $flipped++;
      }
      last; #break at the nearest symbol
    }
  }

  # diagonal, bottom-right to top-left
  $i = $row;
  $j = $col;
  @stack = ();
  while ($i > 0 and $j > 0) {
    $i--;
    $j--;
    if($this->{board}[$i][$j] eq "."){ #it must be adjcent to some symbols
      last; #break and drop the stack
    }
    if($this->{board}[$i][$j] ne "." and $this->{board}[$i][$j] ne $symbol){ #occupied by opponent
      push @stack, [$i,$j]; #mark opponents position in case we have to flip
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack == 0){ #cannot eclose any opponent
      last; #break at the nearest symbol
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack > 0){ #enclosed some opponent
      foreach $position (@stack){ #take out all the stored symbol
        #print "@{$position}[0],@{$position}[1]\n";
        if($dryRun != 1){
          $this->{board}[@{$position}[0]][@{$position}[1]] = $this->{turn}->{symbol}; #actually flip the symbol
        }
        $flipped++;
      }
      last; #break at the nearest symbol
    }
  }


  # diagonal, top-right to bottom-left
  $i = $row;
  $j = $col;
  @stack = ();
  while ($i < 7 and $j > 0) {
    $i++;
    $j--;
    if($this->{board}[$i][$j] eq "."){ #it must be adjcent to some symbols
      last; #break and drop the stack
    }
    if($this->{board}[$i][$j] ne "." and $this->{board}[$i][$j] ne $symbol){ #occupied by opponent
      push @stack, [$i,$j]; #mark opponents position in case we have to flip
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack == 0){ #cannot eclose any opponent
      last; #break at the nearest symbol
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack > 0){ #enclosed some opponent
      foreach $position (@stack){ #take out all the stored symbol
        #print "@{$position}[0],@{$position}[1]\n";
        if($dryRun != 1){
          $this->{board}[@{$position}[0]][@{$position}[1]] = $this->{turn}->{symbol}; #actually flip the symbol
        }
        $flipped++;
      }
      last; #break at the nearest symbol
    }
  }

  # diagonal, bottom-left to top-right
  $i = $row;
  $j = $col;
  @stack = ();
  while ($i > 0 and $j < 7) {
    $i--;
    $j++;
    if($this->{board}[$i][$j] eq "."){ #it must be adjcent to some symbols
      last; #break and drop the stack
    }
    if($this->{board}[$i][$j] ne "." and $this->{board}[$i][$j] ne $symbol){ #occupied by opponent
      push @stack, [$i,$j]; #mark opponents position in case we have to flip
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack == 0){ #cannot eclose any opponent
      last; #break at the nearest symbol
    }
    if($this->{board}[$i][$j] eq $symbol and scalar @stack > 0){ #enclosed some opponent
      foreach $position (@stack){ #take out all the stored symbol
        #print "@{$position}[0],@{$position}[1]\n";
        if($dryRun != 1){
          $this->{board}[@{$position}[0]][@{$position}[1]] = $this->{turn}->{symbol}; #actually flip the symbol
        }
        $flipped++;
      }
      last; #break at the nearest symbol
    }
  }

  return $flipped;
}
sub validate { #search if the move is found in all possible moves
  my $this = shift;
  my $row = shift;
  my $col = shift;
  foreach $position (@{$this->{validMoves}}){
    if(@{$position}[0] == $row and @{$position}[1] == $col){
      return 1;
    }
  }
  return 0;
}

package Player;
sub new {
  my $class = shift;
  my $this = {
    symbol => shift,
  };
  bless $this;
}
sub nextMove {
  my $this = shift;
  return "This is player next move";
}

package Human;
@ISA = qw(Player);
sub new {
  my $class = shift;
  my ($symbol) = @_;
  my $this = Player->new($symbol);
  bless $this;
}
sub nextMove {
  my $this = shift;
  print "Player $this->{symbol}, make a move (row col):";
  my $inp = <>;
  $inp = [split /[\s,]+/, $inp];
  return ($inp->[0], $inp->[1]);
}

package Computer;
@ISA = qw(Player);
sub new {
  my $class = shift;
  my ($symbol) = @_;
  my $this = Player->new($symbol);
  bless $this;
}
sub nextMove { # version 1, easy random moves
  my $this = shift;
  my $validMoves = shift;
  if(scalar @{$validMoves} == 0){
    return (-1,-1);
  }
  else{
    $rand = int(rand(scalar @{$validMoves})); # 0 to arraylength-1
    return @{@{$validMoves}[$rand]};
  }
}

package main;

my $game = Reversi->new();
$game->startGame;