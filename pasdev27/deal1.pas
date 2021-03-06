program prepare_hands;

const mincard = 0;
      maxcard = 51;

type suit = (clubs, diamonds, hearts, spades);
     rank = (two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace);
     hand = array [suit] of set of rank;
     player = (north, east, south, west);
     fulldeal = array [player] of hand;
     card = mincard .. maxcard;
     distribution = array [card] of player;
     cut_size = 5 .. 15;
     arrangement = array [player] of 1 .. 4;
$PAGE initrandom
(*  INITRANDOM will initialize the random number generator, using the runtime
    of this job as an initial seed.  *)

procedure initrandom;

var x: real;

begin
  x := random (runtime);
end;
$PAGE dealcards
(*  DEALCARDS will produce a randomly generated set of hands in the DESC array.
    It begins by producing a random permutation of the integers from 0 to 51.
    It then translates this into a set of hands, using the convention that the
    first 13 integers are the first hand, the second 13 are the second hand, etc.
    The integers 0 to 51 correspond to the cards 2C, 3C, ... AC, 2D, ... KS, AS.  *)

procedure dealcards (var dealtcards: fulldeal; var prepare: distribution);

const mincard = 0;
      maxcard = 51;

type card = mincard .. maxcard;


function suitof (c: card): suit;
begin
  suitof := suit (c div 13);
end;


function rankof (c: card): rank;
begin
  rankof := rank (c mod 13);
end;
$PAGE
var c, c1, c2: card;
    p: player;
    s: suit;
    deal: array [card] of card;

begin
  for c := mincard to maxcard do
    deal [c] := c;
  for c := maxcard downto mincard do begin
    c1 := trunc (random * c);
    c2 := deal [c1];
    deal [c1] := deal [c];
    deal [c] := c2;
  end;
  for p := minimum (player) to maximum (player) do
    for s := minimum (suit) to maximum (suit) do
      dealtcards [p, s] := [];
  for c := mincard to maxcard do begin
    p := player (c div 13);
    s := suitof (deal [c]);
    dealtcards [p, s] := dealtcards [p, s] + [rankof (deal [c])];
    prepare [deal [c]] := p;
  end;
end;
$PAGE randomprep
procedure randomprep (var cut: cut_size; var arrange: arrangement);

var p, p1: player;
    pp: 1 .. 4;

begin
  cut := trunc (random * 11) + 5;
  for p := minimum (player) to maximum (player) do
    arrange [p] := ord (p) + 1;
  for p := maximum (player) downto minimum (player) do begin
    p1 := player (trunc (random * ord (p)));
    pp := arrange [p1];
    arrange [p1] := arrange [p];
    arrange [p] := pp;
  end;
end;
$PAGE suitrow
(*  SUITROW will produce a string representing the cards in a single suit for
    a single hand.  *)

const suitname: array [suit] of char = ( 'C', 'D', 'H', 'S' );
      rankname: array [rank] of string [2] =
	( '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A' );

function suitrow (h: hand; s: suit): string [35];

var r: rank;

begin
  suitrow := suitname [s] || ' -';
  for r := maximum (rank) downto minimum (rank) do begin
    if r in h [s] then
      suitrow := suitrow || ' ' || rankname [r];
  end;
end;
$PAGE printhands
procedure printhands (hands: array [1..*] of fulldeal);

var i: integer;
    s: suit;

begin
  for i := 1 to upperbound (hands) do begin
    if i <> 1 then
      page;
    writeln ('':17, 'NORTH');
    writeln;
    for s := maximum (suit) downto minimum (suit) do
      writeln ('':15, suitrow (hands [i, north], s));
    writeln;
    writeln ('  WEST':32:l, 'EAST');
    writeln;
    for s := maximum (suit) downto minimum (suit) do
      writeln (suitrow (hands [i, west], s):30:l, suitrow (hands [i, east], s));
    writeln;
    writeln ('':17, 'SOUTH');
    writeln;
    for s := maximum (suit) downto minimum (suit) do
      writeln ('':15, suitrow (hands [i, south], s));
  end;
end;
$PAGE printinstructions
procedure printinstructions (cards: array [1..*] of distribution;
			     cuts: array [1..*] of cut_size;
			     arrange: array [1..*] of arrangement);

const
    columns = 8;

var hand_set, first_hand, last_hand, hand: integer;
    cc: 0 .. 12;
    c: card;
    p: player;
    pp: 1 .. 4;

const
    playernames: array [player] of packed array [1..5] of char =
      ( 'NORTH', 'EAST', 'SOUTH', 'WEST' );

begin
  for hand_set := 1 to (upperbound (cards) + columns - 1) div columns do begin
    if not odd (hand_set) then begin
      writeln;
      writeln;
      writeln;
    end
    else if hand_set <> 1 then
      page;
    first_hand := (hand_set - 1) * columns + 1;
    last_hand := min (first_hand + columns - 1, upperbound (cards));
    for hand := first_hand to last_hand do
      write ('': 5, 'DEAL ', hand: 2);
    writeln;
    for hand := first_hand to last_hand do
      write ('': 6, 'CUT ', cuts[hand]: 2);
    writeln;
    writeln;
    for cc := 0 to 12 do begin
      for hand := first_hand to last_hand do begin
	write ('': 4);
	for c := cc * 4 to cc * 4 + 3 do
	  write (arrange [hand, cards [hand, (c + cuts [hand]) mod (maxcard + 1)]]: 2);
      end;
      writeln;
    end;
    writeln;
    for pp := 1 to 4 do begin
      for hand := first_hand to last_hand do begin
	for p := minimum (player) to maximum (player) do begin
	  if arrange [hand, p] = pp then
	    write ('': 5, pp: 1, ' ', playernames [p]);	
	end;
      end;
      writeln;
    end;
  end;
end;
$PAGE prepare_hands - main program
var i, ndeals: integer;
    cards: ^ array [1..*] of fulldeal;
    preps: ^ array [1..*] of distribution;
    cuts: ^ array [1..*] of cut_size;
    arrange: ^ array [1..*] of arrangement;
    fname: file_name;

begin
  initrandom;
  rewrite (tty);
  open (tty);

  write (tty, 'How many hands? ');
  break;
  readln (tty);
  read (tty, ndeals);
  new (cards, ndeals);
  new (preps, ndeals);
  new (cuts, ndeals);
  new (arrange, ndeals);
  for i := 1 to ndeals do begin
    dealcards (cards^[i], preps^[i]);
    randomprep (cuts^[i], arrange^[i]);
  end;

  write (tty, 'Output file? ');
  break;
  readln (tty);
  read (tty, fname);

  rewrite (output, fname || '.LST');
  printhands (cards^);
  writeln (tty);
  writeln (tty, 'Hand listings are on ', filename (output));
  close (output);

  rewrite (output, fname || '.INS');
  printinstructions (preps^, cuts^, arrange^);
  writeln (tty);
  writeln (tty, 'Preparation instructions are on ', filename (output));
  close (output);
end.
 