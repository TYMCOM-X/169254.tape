$TITLE DEBSYM - Pascal Debugger interface to the symbol table files

$HEADER debsym
  
module debsy$  options nocheck, special (coercions, word, ptr);

$INCLUDE debug.typ
  
$INCLUDE debio.inc                      (* used by ERROR *)
$INCLUDE deblib.inc                     (* ST$BASE, ST$LEN and DB$OPEN *)
$PAGE constant and type declarations
const
  max_buffers := 16;                            (* maximum number of disk block buffers *)
  
type
  errcodes = (dsk_rd_err, open_failure);        (* codes used by fatal error routine *)
  buffer_index = 1..max_buffers;                (* legal buffer indicies *)
  map_entry = packed record                     (* entry in map table *)
    lru_count: machine_word;                                (* just value of BLK_LRU_CNTR at time of
                                                           call to DEREF$PTR *)
    block_num: machine_word                         (* block/buffer mapping *)
  end;
  map_array = packed array [buffer_index] of map_entry;
  buf_array = array [1..max_buffers] of disk_block;
  
  (* Static storage record for module.  The address and length of this
     region is passed to ST$INIT which then determines the actual number
     of buffers available. *)

  st_static_record = record
    num_buffers: buffer_index;                  (* actual number of buffers, set by ST$INIT *)
    last_blk_used: 0..max_buffers;              (* next virgin blk in buffer area follows this one *)
    blk_lru_cntr: machine_word;                     (* incremented whenever DEREF$PTR is called *)
    symtab_file: file of disk_block;    (* file variable for reading.deb files *)
    cur_files_name: file_name_string;           (* name of file currently open; if not null
                                                   then named file is assumed to be open *)
    map_table: map_array;                       (* block/buffer map and lru counts *)
    buffers: buf_array                          (* the buffers; actual number determined dynamically *)
  end;
$PAGE fatal_error
(* FATAL_ERROR is a fatal error handler.  It prints a message based on the error
   code passed in parameter ERRNUM and then STOPs. *)

procedure fatal_error (errnum:          errcodes;
                       symfile_name:    file_name_string);

begin
  case errnum of

    dsk_rd_err:
      writ$str ('Read error on symbol table file: ');

    open_failure:
      writ$str ('Unable to open symbol table file: ')

  end;

  writ$str (substr (symfile_name, 1, search (symfile_name, ['.'])));
  writ$nl ('DEB');
  writ$nl ('Fatal Debugger error');
  stop                                          (* FATAL !!! *)
end;
$PAGE init_map_table
(* INIT_MAP_TABLE initializes the map table by setting all LRU_COUNTs
   to zero, BLOCK_NUMs to 0 and variable LAST_BLK_USED to zero.  *)

procedure init_map_table;

var
  i: buffer_index;

begin
  with st$base^ do begin
    for i := 1 to num_buffers do
      with map_table[i] do begin
        lru_count := 0;
        block_num := 0
      end;
    last_blk_used := 0
  end
end;
$PAGE st$init
(* ST$INIT must be called once before any of the other routines
   of this module are called.  It calculates the number of buffers
   it will have available and initializes the module's static storage record. *)

public procedure st$init;

begin
  with st$base^ do begin
    num_buffers := (st$len - (size (st_static_record) - size (buf_array))) div block_size;
    blk_lru_cntr := 0;
    cur_files_name := '';
    init_map_table                              (* init map table and LAST_BLK_USED *)
  end
end;
$PAGE st$open
(* ST$OPEN opens a symbol table file if it is not already open.
   Parameter SYMFILE_NAME is the name of the symbol table file.  
   A fatal (i.e. no return) error will occur if the file cannot be opened. 
   The map table is reinitialized if the file was not already open. *)

public procedure st$open (symfile_name: file_name_string);

begin
  with st$base^ do
    if symfile_name <> cur_files_name then begin (* not already open *)
      if cur_files_name <> '' then
        close (symtab_file);
      cur_files_name := symfile_name;
      db$open (symtab_file, symfile_name || ' DSK: ', [seekok, retry]);
      if iostatus (symtab_file) <> io_ok then
        db$open (symtab_file, symfile_name || ' DSK: []', [seekok, retry]); (* use current search list *)
      if iostatus (symtab_file) <> io_ok then
        fatal_error (open_failure, symfile_name); (* fatal! *)
      init_map_table                            (* reinitialize map table *)
    end
end;
$PAGE st$file
(* ST$FILE returns the name of the currently open file.  The null
   string is returned if no file is currently open.  *)
 
public function st$file: file_name_string;

begin
  st$file := st$base^.cur_files_name
end;
$PAGE deref$ptr
(* DEREF$PTR converts a symbol table file offset to a pointer to a
   symbol table node.  (The pointers in the .DEB file are word offsets
   relative to the base of the .DEB file.)   *) 

public function deref$ptr (offset: half_word): ptr;

const
  num_blocks := 1;                              (* number of blocks to read at one time *)

var
  index:        buffer_index;           (* used to index map table *)
  word:         0..block_size - 1;              (* word offset into disk block *)
  block:        pos_int;        (* relative block from st base *)
  static_base:  ^st_static_record;      (* ptr to base of static storage record *)
$PAGE getblock - in deref$ptr
(* GETBLOCK returns the index of a buffer for the next disk read.
   If there is an unused buffer then its index will be returned;
   otherwise the least recently used buffer's index is returned. *)

function getblock: buffer_index;

var
  temp: buffer_index;

begin
  with static_base^ do begin
    if last_blk_used >= num_buffers then begin  (* no more unused blocks *)
      getblock := 1;
      for temp := 2 to num_buffers do 
        if map_table[getblock].lru_count > map_table[temp].lru_count then
          getblock := temp
    end
    else begin                                  (* unused blocks left - just grab next one *)
      last_blk_used := last_blk_used + 1;
      getblock := last_blk_used
    end
  end
end;
$PAGE searchmap - in deref$ptr
(* SEARCHMAP returns the value true if the disk block (of the
   currently open file) specified by parameter BLK is currently
   in core.  If it is then parameter IDX will be set to the index
   of the desired buffer.  If the block is not in core, the value
   false is returned.  *)

function searchmap (    blk:    machine_word;
                    var idx:    buffer_index): boolean;

begin
  with static_base^ do begin
    idx := 1;
    searchmap := true;
    while idx <= last_blk_used do
      if blk = map_table[idx].block_num then
        return                          (* <-- return if block found *)
      else
        idx := idx + 1;
    searchmap := false                          (* not found *)
  end
end;
$PAGE deref$ptr - body
begin
  if offset = ord (NIL) then
    deref$ptr := NIL
  else begin
    static_base := st$base;
    with static_base^ do begin
      word := offset mod block_size;
      block := (offset div block_size) + 1;
      if not searchmap (block, index) then begin  (* returns index if true *)
        index := getblock;
        seek (symtab_file, block);
        buffers [index] := symtab_file^;
        if iostatus (symtab_file) <> io_ok then
          fatal_error (dsk_rd_err, st$file);  (* fatal ! *)
        map_table[index].block_num := block
      end;

      deref$ptr := ptr (ord (address (buffers[index])) + word);
      
      blk_lru_cntr := blk_lru_cntr + 1;
      map_table[index].lru_count := blk_lru_cntr
    end
  end
end.
    