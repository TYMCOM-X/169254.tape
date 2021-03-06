
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  39*)
(*TEST 6.2.1-8, CLASS=QUALITY*)
(* This test checks that a large number of types may be declared
  in a program. It is an attempt to discover any small limit imposed
  on the number of types by a compiler. *)
program t6p2p1d8;
type
   t1 = 0..1;
   t2 = 0..2;
   t3 = 0..3;
   t4 = 0..4;
   t5 = 0..5;
   t6 = 0..6;
   t7 = 0..7;
   t8 = 0..8;
   t9 = 0..9;
   t10 = 0..10;
   t11 = 0..11;
   t12 = 0..12;
   t13 = 0..13;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   t14 = 0..14;
   t15 = 0..15;
   t16 = 0..16;
   t17 = 0..17;
   t18 = 0..18;
   t19 = 0..19;
   t20 = 0..20;
   t21 = 0..21;
   t22 = 0..22;
   t23 = 0..23;
   t24 = 0..24;
   t25 = 0..25;
   t26 = 0..26;
   t27 = 0..27;
   t28 = 0..28;
   t29 = 0..29;
   t30 = 0..30;
   t31 = 0..31;
   t32 = 0..32;
   t33 = 0..33;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   t34 = 0..34;
   t35 = 0..35;
   t36 = 0..36;
   t37 = 0..37;
   t38 = 0..38;
   t39 = 0..39;
   t40 = 0..40;
   t41 = 0..41;
   t42 = 0..42;
   t43 = 0..43;
   t44 = 0..44;
   t45 = 0..45;
   t46 = 0..46;
   t47 = 0..47;
   t48 = 0..48;
   t49 = 0..49;
   t50 = 0..50;
var
   v1 : t1;
   v2 : t2;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   v3 : t3;
   v4 : t4;
   v5 : t5;
   v6 : t6;
   v7 : t7;
   v8 : t8;
   v9 : t9;
   v10 : t10;
   v11 : t11;
   v12 : t12;
   v13 : t13;
   v14 : t14;
   v15 : t15;
   v16 : t16;
   v17 : t17;
   v18 : t18;
   v19 : t19;
   v20 : t20;
   v21 : t21;
   v22 : t22;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   v23 : t23;
   v24 : t24;
   v25 : t25;
   v26 : t26;
   v27 : t27;
   v28 : t28;
   v29 : t29;
   v30 : t30;
   v31 : t31;
   v32 : t32;
   v33 : t33;
   v34 : t34;
   v35 : t35;
   v36 : t36;
   v37 : t37;
   v38 : t38;
   v39 : t39;
   v40 : t40;
   v41 : t41;
   v42 : t42;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   v43 : t43;
   v44 : t44;
   v45 : t45;
   v46 : t46;
   v47 : t47;
   v48 : t48;
   v49 : t49;
   v50 : t50;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #039');
   writeln(' 50 TYPES COMPILED...6.2.1-8')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   