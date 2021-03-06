module vax_size options special, nocheck;
$system pascal.inc
$system pasfil.inc
$system pasist.inc
$system ptmcon.inc
$system dtime.inc
$PAGE
public procedure locate (
	b: blk;
	t: typ;
	s: sym;
	vl: val_ptr;
	n: nam;
	var v: val );

var p: ptr;

begin
  with b^ do begin
    parent := nil;
    peer := nil;
    children := nil;
    return_sym := nil;
    p := address (parm_list);
    p := address (label_list);
    p := address (type_list);
    p := address (id_list);
    parm_list.first := nil;
    parm_list.last := nil;
    label_list.first := nil;
    label_list.last := nil;
    type_list.first := nil;
    type_list.last := nil;
    id_list.first := nil;
    id_list.last := nil;
    owner := nil;
    downward_call_thread := nil;
    upward_call_thread := nil;
    lex_thread := nil;
    id := nil;
    subr_sym := nil;
    class_type := nil;
  end;
  with t^ do begin
    type_id := nil;
    base_type := nil;
    p := address (cst_list);
    cst_list.first := nil;
    cst_list.last := nil;
    set_element_type := nil;
    target_type := nil;
    heap_class := nil;
    element_type := nil;
    index_type := nil;
    component_type := nil;
    file_class := nil;
    field_list := nil;
    variant_tag := nil;
    tag := nil;
    next_variant := nil;
    tag_field := nil;
    tag_type := nil;
    tag_recvar := nil;
    first_variant := nil;
    class_block := nil;
    return_type := nil;
    p := address (params);
    params[1].parm_type := nil;
    actual_type := nil;
  end;
  with s^ do begin
    name := nil;
    block := nil;
    next := nil;
    scopechain := nil;
    type_desc := nil;
    fld_record := nil;
    fld_variant := nil;
    p := address ( init_value);
  end;
  with vl^ do begin
    def_addr := nil;
    struc_type := nil;
    p := address (elem_vals[1]);
  end;
  with v do begin
    valp := nil;
    blkp := nil;
    defp := nil;
  end;
  with n^ do begin
    alink := nil;
    zlink := nil;
    scopechain := nil;
  end;
end.
  