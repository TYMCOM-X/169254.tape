$IF LINK1 module LINK1;
$IF LINK2 module LINK2;

$IF VER1 Const VERSTR : String := ' Version 1';
$IF VER2 Const VERSTR : String := ' Version 2';

$IF LINK1 Const LINKID : String := 'LINK1' || VERSTR;
$IF LINK2 Const LINKID : String := 'LINK2' || VERSTR;

$IF LINK1 const LINKID_NO : Integer := 1;
$IF LINK2 const LINKID_NO : Integer := 2;

$IF LINK1 Public Var PUB_LINK1_VAR: String := 'Public ' || LINKID ||' Var String.';
$IF LINK2 Public Var PUB_LINK2_VAR: String := 'Public ' || LINKID ||' Var String.';
$IF LINK1 Public Const PUB_LINK1_CST: String:= 'Public ' || LINKID ||' Const string.';
$IF LINK2 Public Const PUB_LINK2_CST: String:= 'Public ' || LINKID ||' Const string.';

Type PROC_ARY_TYP = Array [ 0..4 ] of String [ 5 ];
Const PROC_ARY : PROC_ARY_TYP := ('MAIN', 'LINK1', 'LINK2', 'PLOT1', 'PLOT2' );

External Procedure MAIN1 ( integer );
$IF LINK1 External Procedure LINK2 ( integer );
$IF LINK2 External Procedure LINK1 ( integer );

External Var PUB_MAIN_VAR : String;
External Const PUB_MAIN_CST : String;

$IF LINK1 External Var PUB_LINK2_VAR : String;
$IF LINK1 External Const PUB_LINK2_CST : String;
$IF LINK2 External Var PUB_LINK1_VAR : String;
$IF LINK2 External Const PUB_LINK1_CST : String;
var I : integer;
    max_ok_addr : integer;
    ptr_rec : ^integer;
$PAGE LINK OVERLAY
$IF LINK1 Public Procedure LINK1 ( FROM : Integer );
$IF LINK2 Public Procedure LINK2 ( FROM : Integer );

Begin

$IF LINK2 I := I + 1 + 2 + 3 - 3 - 2 - 1;
$IF VER2 I := I -3 -2 - 1;

  writeln ( tty , LINKID , ' called from ' , PROC_ARY [ FROM ] );

  loop

    write ( tty , LINKID , '.  Enter test number: ' );
    break ( tty );
    readln ( tty );
    read ( tty , I );
  exit if I = 0;
    case I of
      1: main1 ( 1 );
$IF LINK1 2: LINK2 ( LINKID_NO );
$IF LINK2 2: link1 ( LINKID_NO );
      3: begin
	   writeln ( tty ,'Displaying MAINS public consts and vars.' );
	   writeln ( tty , 'MAINS public var: ' , PUB_MAIN_VAR );
	   writeln ( tty , 'MAINS public const: ' , PUB_MAIN_CST )
	 end;
      4: begin
	   writeln ( tty , 'Displaying ',LINKID,' public consts and vars.' );
$IF LINK1 writeln ( tty , LINKID , ' public var: ' , PUB_LINK2_VAR );
$IF LINK2 writeln ( tty , LINKID , ' public var: ' , PUB_LINK1_VAR );
$IF LINK1 writeln ( tty , LINKID , ' public const: ' , PUB_LINK2_CST )
$IF LINK2 writeln ( tty , LINKID , ' public const: ' , PUB_LINK1_CST )
	 end;
      5: Begin
	   write ( tty , 'Max correct address: ' );
	   break ( tty );
	   readln ( tty );
	   read ( tty , max_ok_addr );
	   loop
	     new ( ptr_rec );
	     if max_ok_addr > ord ( ptr_rec )
		then writeln ( tty , '??? Heap addr used: ', ord ( ptr_rec));
	   end
	 end;
      others: writeln ( tty , 'Try again. 0..5 only!' )
    end

  end;		(* loop *)

end.
  