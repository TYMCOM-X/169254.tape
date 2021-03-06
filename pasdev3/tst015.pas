(* TST015 - general tests.  This module must be linked with TST016
   in order to be executed.  *)

program tst015;

$DISABLE generics
$DISABLE aggregates

type
$IF GENERICS  gen_array = packed array [*] of 0..255;
$IFNOT GENERICS gen_array = packed array [-3..*] of 0..255;

external procedure hab ( var integer; gen_array );
external var pub_var: integer;

type 
  oof_rec = packed record
    lhword: 0..777777b;
    rhword: 0..777777b;
    next: ^oof_rec
  end;
  
  colors = (purple, red, blue, yellow, green, orange);
  rgb = red..green;
  rgb_set = set of rgb;
  flex_fstring = packed array [1..*] of char;
  neg_rec = packed record
    lhword: -400000b..377777b;
    rhword: 0..777777b
  end;

const
  red_set: rgb_set := [red];


var
  gene: ^gen_array;
  j,k: integer;
  bool: boolean;
  color: rgb;
  color_set: rgb_set;
  oof_rec_ptr: ^oof_rec;
  int_array: packed array [1..5] of 0..255;
  ch: char;
  neg_rec1: neg_rec;
  neg_rec2: neg_rec;
  flx_str: ^flex_fstring;
  x: real;

$PAGE oof

public procedure oof ( a: integer );

var
  i: integer;
  oof_record: oof_rec;


function oof_son ( level: integer; value_rec: oof_rec; flex: flex_fstring ): oof_rec;

  var
    result: oof_rec;
    lh, rh: integer;
  begin
    writeln ( ttyoutput, 'Begin function OOF_SON' );
    break ( ttyoutput );
    writeln ( ttyoutput, 'level: ', level );
    writeln ( ttyoutput, 'value_rec: ', value_rec.lhword, '   ',  value_rec.rhword,
      	      '   ', ord ( value_rec.next ):12:o );
    writeln ( ttyoutput, 'flex: ', flex );
$IF AGGREGATES    oof_son := ( 7, 9, nil );
$IFNOT AGGREGATES
    with oof_son do begin
      lhword := 7;
      rhword := 9;
      next := nil;
    end;
$ENDIF
    writeln ( ttyoutput, 'oof_son: ', oof_son.lhword, oof_son.rhword,
	      ord ( oof_son.next ):12:o );
    i := a * 13 + 1;
    writeln ( ttyoutput, 'i: ', i );
    if level > 0 then begin
$IF AGGREGATES      result := oof_son ( level - 1, (7,777b, nil), 'abc' );
$IFNOT AGGREGATES
      with result do begin
        lhword := 7;
        rhword := 777b;
        next := nil;
      end;
      result := oof_son ( level - 1, result, 'abc' );
$ENDIF
      writeln ( ttyoutput, 'result: ', result.lhword, result.rhword, 
	        ord ( result.next ):12:o );
    end;
    lh := value_rec.lhword;
    writeln ( ttyoutput, 'lh: ', lh );
    rh := -1;
    writeln ( ttyoutput, 'rh: ', rh );
    i := upperbound ( flex );
    writeln ( ttyoutput, 'i: ', i );
    writeln ( ttyoutput, 'End function OOF_SON' );
    break ( ttyoutput );
  end;


  
begin
  writeln ( ttyoutput, 'Begin procedure oof' );
  break ( ttyoutput );
  writeln ( ttyoutput, 'a: ', a );
  i := 3;
  writeln ( ttyoutput, 'i: ', i );
$IF AGGREGATES  oof_record := oof_son ( 2, (4,8, nil), substr( '12345678901', i, 6 )  );
$IFNOT AGGREGATES
  with oof_record do begin
    lhword := 4;
    rhword := 8;
    next := nil;
  end;
  oof_record := oof_son ( 2, oof_record, substr ( '12345678901', i, 6 ) );
$ENDIF
  writeln ( ttyoutput, 'oof_record: ', oof_record.lhword, oof_record.rhword,
	    ord ( oof_record.next ):12:o );
  j := 9 + a;
  writeln ( ttyoutput, 'j: ', j );
  writeln ( ttyoutput, 'End of procedure OOF' );
  break ( ttyoutput );
end;

$PAGE tst015 - body
begin
  open ( tty );
  rewrite ( ttyoutput );
  writeln( ttyoutput, 'Beginning TST015' );
  break ( ttyoutput );
  j := 7;
  k := 11;
  bool := j <> k;
  writeln ( ttyoutput, 'j: ', j, '     k: ', k, '     bool: ', bool );
  color := green;
  writeln ( ttyoutput, 'color: ', ord ( color ) );
  color_set := [];
  if color_set = []
    then writeln ( ttyoutput, 'color_set is empty' )
    else writeln ( ttyoutput, 'color_set is NOT empty' );
  bool := purple in color_set;
  writeln ( ttyoutput, 'bool: ', bool );
  color_set := [red, blue];
  if color_set = [red..blue]
    then writeln ( ttyoutput, 'color set ok' )
    else writeln ( ttyoutput, 'color set NOT ok' );
  bool := green in color_set;
  writeln ( ttyoutput, 'bool: ', bool );
  oof ( k );
$IF AGGREGATES  hab ( k, (3, 6, 9, 12, 15, 18) );
$IFNOT AGGREGATES
  new ( gene, 2 );
  gene^[ -3 ] := 3;
  gene^[ -2 ] := 6;
  gene^[ -1 ] := 9;
  gene^[ 0 ]  := 12;
  gene^[ 1 ]  := 15;
  gene^[ 2 ]  := 18;
  hab ( k, gene^ );
$ENDIF
  new ( oof_rec_ptr );
  writeln ( ttyoutput, 'oof_rec_ptr: ', ord ( oof_rec_ptr ):12:o );
  with oof_rec_ptr^ do begin
    lhword := 5;
    rhword := 15;
  end;
  new ( oof_rec_ptr^.next );
  writeln ( ttyoutput, 'oof_rec_ptr^: ', oof_rec_ptr^.lhword,
            oof_rec_ptr^.rhword, ord ( oof_rec_ptr^.next ):12:o );
$IF AGGREGATES  oof_rec_ptr^.next^ := (22, 222, nil );
$IFNOT AGGREGATES
  with oof_rec_ptr^.next^ do begin
    lhword := 22;
    rhword := 222;
    next := nil;
  end;
$ENDIF.
  new ( oof_rec_ptr^.next^.next );
  writeln ( ttyoutput, 'oof_rec_ptr^.next^: ', oof_rec_ptr^.next^.lhword,
	    oof_rec_ptr^.next^.rhword, ord ( oof_rec_ptr^.next^.next ):12:o );
$IF AGGREGATES  oof_rec_ptr^.next^.next^ := (33, 333, nil);
$IFNOT AGGREGATES
  with oof_rec_ptr^.next^.next^ do begin
    lhword := 33;
    rhword := 333;
    next := nil;
  end;
$ENDIF
  writeln ( ttyoutput, 'oof_rec_ptr^.next^.next^: ',
  	    oof_rec_ptr^.next^.next^.lhword, oof_rec_ptr^.next^.next^.rhword,
	    ord ( oof_rec_ptr^.next^.next^.next ):12:o );
$IF AGGREGATES  neg_rec1 := ( -1, 1 );
$IFNOT AGGREGATES
  with neg_rec1 do begin
    lhword := -1;
    rhword := 1;
  end;
$ENDIF
  writeln ( ttyoutput, 'neg_rec1: ', neg_rec1.lhword, neg_rec1.rhword );
$IF AGGREGATES  neg_rec2 := ( -400000b, 377777b );
$IFNOT AGGREGATES
  with neg_rec2 do begin
    lhword := -400000b;
    rhword := 377777b;
  end;
$ENDIF
  writeln ( ttyoutput, 'neg_rec2: ', neg_rec2.lhword, neg_rec2.rhword );
  new ( flx_str, 11 );
  flx_str^ := 'Flextastic';
  writeln ( ttyoutput, 'flx_str^: ', flx_str^ );
  k := upperbound ( flx_str^ );
  writeln ( ttyoutput, 'k: ', k );
  k := -2;
  x := sin ( 1 );
  writeln ( ttyoutput, 'x: ', x );
  j := max ( 7, k , 32 );
  writeln ( ttyoutput, 'j: ', j );
  writeln ( ttyoutput, 'End program TST015' );
end.
   