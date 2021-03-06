PROGRAM Widgit_Orders;
  (* Program                : Widgit_Orders
    Date                   : May 11, 1982
    Programmer             : Julie Smith
 
        This program was written to practice using the language PASCAL.
   The program implements a list of widgit orders for billing and
   delivery purposes.  Each order consists of a costomer name, an order number,
   the quantity of widgits ordered, the color ordered, delivery date 
   requested, and the total amount due.
 
       The available operations on the order list are:
   1. Add an order
   2. Delete an order
 
       The input for the program is constructed as follows:
   1. Add
    A <customer name> <order # > <quantity ordered> <color ordered> <date>
   2. Delete
    D <order #>
 
   Warning...
     All input is assumed to be valid.  No error checking is done.
*)
$PAGE Declarations
CONST Widgit_Cost  = 2.5;       (*Widgits cost $2.50 each*)
 
TYPE  Date = RECORD
                 
               Mo : 1..12;
               Da : 1..31;
               Yr : 1982..2000
             END;
 
     Order = RECORD

               Cust_Name : PACKED ARRAY [1..10] OF Char;
               Order_Num : 1..1000;
               Quantity  : Integer;
               Color     : PACKED ARRAY [1..6] OF Char;
               Deliv_Date: Date;
               Amount_Due: Real;
               Next      : ^Order;
             END;
 
VAR First       : ^Order;       (*Points to the first order in the list*)
    Command     : Char;       (*Holds the command ('A' or 'D') read from the input*)
    Data        : Text;       (*Data file*)
    Data_File   : STRING [ 10 ];
    test_res    : boolean;
$PAGE Add
PROCEDURE Add;
  
  VAR New_Order,               (*Points to newly created order*)
      Current_Order : ^Order;   (*Pointer travels down the list*)
 
  BEGIN
    GET(Data);       (*Skip a space between command and first field*)
 
    NEW(New_Order);   (*Allocate  space for new order*)
 
    WITH New_Order ^ DO
    BEGIN
      READ(Data,Cust_Name, Order_Num, Quantity, Color);
      WITH Deliv_Date DO
        READ(Data,Mo, Da, Yr);
      Amount_Due := Widgit_Cost * Quantity;
      Next := NIL;

      (*Echo the input command*)
      WRITELN(TTY,'Add', Cust_Name : 11, Order_Num); BREAK(TTY);
    END;
 
 
    (*Insert the new order at the end of the list*)
    IF First = NIL
      THEN First := New_Order
      ELSE BEGIN
             Current_Order := First;
             WHILE Current_Order^.Next <> NIL DO
               Current_Order := Current_Order^.Next;
             Current_Order^.Next := New_Order
           END
  END;
$PAGE Delete
PROCEDURE Delete;
  
  VAR Order_Num       : Integer;
      Current_Order   : ^Order;
      Found           : Boolean;
      Temp            : ^Order;

  BEGIN
    READ(Data,Order_Num);
 
    (*Echo the input*)
    WRITELN(TTY,'Delete', Order_Num); BREAK(TTY);

    Found := FALSE;
    Current_Order := First;
 
    (*Delete the order with the given order number, from the list*)
    IF Order_Num = Current_Order^.Order_Num
      THEN BEGIN
             Temp := First^.Next;
             DISPOSE(First);
             First := Temp;
             Found := TRUE
           END;

    IF NOT Found
      THEN BEGIN
             WHILE (Current_Order^.Next <> NIL) AND NOT Found DO
             BEGIN
               IF Order_Num = Current_Order^.Next^.Order_Num
                 THEN BEGIN
                        (*Delete the order*)
                        Temp := Current_Order^.Next^.Next;
                        DISPOSE(Current_Order^.Next);
                        Current_Order^.Next := Temp;
                        Found := TRUE
                      END
                 ELSE Current_Order := Current_Order^.Next
             END
           END
  END;
$PAGE Print_Order_List
PROCEDURE Print_Order_List;
 
  VAR   Current_Order : ^Order;
 
  BEGIN
    WRITELN(TTY);
    WRITELN(TTY);
    WRITELN(TTY,'Customer orders for Acme Widgit Co'); BREAK(TTY);
    WRITELN(TTY);
    WRITELN(TTY,'Customer Name Order # Quantity Color Delivery Date Amt Due'); BREAK(TTY);
    
    Current_Order := First;
 
    WHILE Current_Order <> NIL DO
    BEGIN
      WITH Current_Order^ DO
      BEGIN
        WRITE(TTY,Cust_name : 13, Order_Num : 8, Quantity : 9, Color : 6); BREAK(TTY);
        WITH Deliv_Date DO
        BEGIN
          CASE Mo OF
            1 : WRITE(TTY,'Jan' : 5);
            2 : WRITE(TTY,'Feb' : 5);
            3 : WRITE(TTY,'Mar' : 5);
            4 : WRITE(TTY,'Apr' : 5);
            5 : WRITE(TTY,'May' : 5);
            6 : WRITE(TTY,'Jun' : 5);
            7 : WRITE(TTY,'Jul' : 5);
            8 : WRITE(TTY,'Aug' : 5);
            9 : WRITE(TTY,'Sep' : 5);
            10 : WRITE(TTY,'Oct' : 5);
            11 : WRITE(TTY,'Nov' : 5);
            12 : WRITE(TTY,'Dec' : 5);
          END;
          BREAK(TTY);
          WRITE(TTY,Da : 3, ',', Yr : 5); BREAK(TTY);
        END;

        WRITELN(TTY,' $', Amount_Due : 7 : 2); BREAK(TTY);
      END;
      Current_Order := Current_Order^.Next
    END
  END;
$PAGE Mainline
(**** MAIN PROGRAM ****)
 
BEGIN
  REWRITE(TTY);
  WRITELN(TTY,'Widgit Program               May 1982');
  WRITELN(TTY);
  BREAK(TTY);
  OPEN(TTY);
  WRITE(TTY,'Enter data file name:');
  BREAK(TTY);
  READLN(TTY);
  READ(TTY,Data_File);
  WRITELN(TTY,Data_File); 
  BREAK(TTY);
  RESET(Data, Data_File);
  WRITELN(TTY,'Data has been associated with data_file');
  BREAK(TTY);

  (*Initialize list of orders to nil*)
  First := NIL;


  WHILE NOT EOF(Data) DO
    BEGIN
      READ(Data,Command);      
      WRITELN(TTY,'Command is ', Command);
      BREAK(TTY);
 
      IF Command = 'A'
        THEN Add        (*Add order to list*)
        ELSE Delete;    (*Delete order from the list*)

      READLN(Data)
    END;
 
  Print_Order_List
END.
  