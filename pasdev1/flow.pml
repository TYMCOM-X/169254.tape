PMF VERSION 2.0 LIB FILE
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
M 12 107 DEFINE_LISTS
))~A!,"nodes),#literal ("edge_list_&#num("nodes+1))#assign (nodes,"#num("nodes+1))define_lists (~A!#if("#gtn(
E
M 7 55 #LABELS
+1)))~A!,"nodes),#labels("#num(~A!:>&#if("#nen(~A!<:,    
E
E
E
E
E
E
E
E
E
E
E
E
E
M 8 135 GEN_CODE
+1)))~A!,"nodes),gen_code("#num(~A!)  <:end;:>)#if ("#nen(~A!),  stop;,  case i of&gen_jumps (1,"edge_list_~A!:#if ("#eqc("edge_list_~A!
M 5 145 GRAPH
:>;var i: integer;~A!#assign (graph,#error (Only one GRAPH statement allowed))#opsyn (edge,edge_)#opsyn (end,end_)#literal (nodes,0)program <:
E
E
M 5 103 EDGE_
 *):>~A" -> ~A!|)<:(* EDGE ~A"&~A!,"edge_list_~A!))#assign (edge_list_~A",~A!),~A",~A!define_lists ("#if("#gtn(
E
M 9 151 GEN_JUMPS
,"ind+1),;))~A"+1),"#substr(~A!,1,"ind-1)&gen_jumps ("#num(~A"): goto #substr(~A!,1),others,~A!    #if ("#eqn(~A#,|))~A"),#assign (ind,"#search(~A"#if ("#nec(
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
M 4 38 EDGE
#error (First statement must be GRAPH)
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
M 4 54 END_
label    1&#labels (2);begingen_code (1)<:end.:>
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
M 3 27 END
#error (No graph specified)
E
E
E
E
L 3 0 IND

E
E
E
E
E
E
E
  