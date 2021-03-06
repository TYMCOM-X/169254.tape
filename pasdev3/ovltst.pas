Program OVERLAY_TEST;

$include mapimg.typ
$include mapimg.inc

Public Var PUB_MAIN_VAR : String := 'MAIN. Public Var String.';

Public Const PUB_MAIN_CST : String := 'MAIN. Public Const String.';

External Procedure LINK1 ( integer );
External Procedure LINK2 ( integer );

External Procedure PLOT1 ( integer );
External Procedure PLOT2 ( integer );

Type PROC_ARY_TYP = Array [ 0..4 ] Of String [ 5 ];

Public Const PROC_ARY : PROC_ARY_TYP := ('MAIN', 'LINK1' , 'LINK2', 'PLOT1', 'PLOT2' );

Var I : Integer;
    map_status : mif_status;

type map_cst_typ = array [ mif_status ] of string;

const map_cst : map_cst_typ := ('Mapped successfully.' ,
				'%MIF Open failure.',
				'%MIF Mapping failure.',
				'%MIF Close failure.' );
$PAGE MAIN1
Public Procedure MAIN1 ( FROM : Integer );

Begin
  Writeln ( tty , 'MAIN1. Called from ' , PROC_ARY [ FROM ] );

  Loop
    Write ( tty , 'MAIN1. Enter test number: ' );
    Break ( tty );
    Readln ( tty );
    Read ( tty , I );
  Exit If I = 0;

    Case I of
      1: LINK1 ( 0 );
      2: LINK2 ( 0 );
      3: PLOT1 ( 0 );
      4: PLOT2 ( 0 );
      11: begin
	   writeln ( tty , 'Mapping Link Version 1.' );
	   map_link_image ( 'link1.exe' , map_status );
	   writeln ( tty , map_cst [ map_status ] )
	  end;
      12: begin
	   writeln ( tty , 'Mapping Link Version 2.' );
	   map_link_image ( 'link2.exe' , map_status );
	   writeln ( tty , map_cst [ map_status ] )
	  end;
      21: begin
	   writeln ( tty , 'Mapping Plot Version 1.' );
	   map_plot_image ( 'plot1.exe' , map_status );
	   writeln ( tty , map_cst [ map_status ] )
	  end;
      22: begin
	   writeln ( tty , 'Mapping Plot Version 2.' );
	   map_plot_image ( 'plot2.exe' , map_status );
	   writeln ( tty , map_cst [ map_status ] )
	  end;
      Others: Writeln ( tty , 'Try again. 0..4,11,12,21,22 only!' );
    End
  End;		(* loop *)

End;		(* MAIN1 *)
$PAGE MAIN
Begin
  open ( tty );
  rewrite ( ttyoutput );

  loop
    write ( tty , 'MAIN. Enter test number: ' );
    break ( tty );
    readln ( tty );
    read ( tty , I );

  exit If I = 0;

    Case I of
      1: LINK1 ( 0 );
      2: LINK2 ( 0 );
      3: PLOT1 ( 0 );
      4: PLOT2 ( 0 );
      11: begin
	   writeln ( tty , 'Mapping Link Version 1.' );
	   map_link_image ( 'link1.exe' , map_status );
	   writeln ( tty , map_cst [ map_status ] )
	  end;
      12: begin
	   writeln ( tty , 'Mapping Link Version 2.' );
	   map_link_image ( 'link2.exe' , map_status );
	   writeln ( tty , map_cst [ map_status ] )
	  end;
      21: begin
	   writeln ( tty , 'Mapping Plot Version 1.' );
	   map_plot_image ( 'plot1.exe' , map_status );
	   writeln ( tty , map_cst [ map_status ] )
	  end;
      22: begin
	   writeln ( tty , 'Mapping Plot Version 2.' );
	   map_plot_image ( 'plot2.exe' , map_status );
	   writeln ( tty , map_cst [ map_status ] )
	  end;
      Others: Writeln ( tty , 'Try again. 0..4,11,12,21,22 only!' )
    End
  end
end.
    