class ['a] typed_notebook default_build nb =
object(self)
  inherit GPack.notebook nb as super
  val mutable typed_page_list = []
  
  method append_typed_page ?(build=default_build) (typed_page:'a) =
    let tab_label,menu_label,page = build typed_page in
    let real_pos = super#append_page ?tab_label ?menu_label page in
    let lower,higher = Util.list_split_at real_pos typed_page_list in
      typed_page_list <- lower@[typed_page]@higher;
      real_pos

  method insert_typed_page ?(build=default_build) ?pos (typed_page:'a) =
    let tab_label,menu_label,page = build typed_page in
    let real_pos = super#insert_page ?tab_label ?menu_label ?pos page in
    let lower,higher = Util.list_split_at real_pos typed_page_list in
      typed_page_list <- lower@[typed_page]@higher;
      real_pos

  method prepend_typed_page ?(build=default_build) (typed_page:'a) =
    let tab_label,menu_label,page = build typed_page in
    let real_pos = super#prepend_page ?tab_label ?menu_label page in
    let lower,higher = Util.list_split_at real_pos typed_page_list in
      typed_page_list <- lower@[typed_page]@higher;
      real_pos

  method set_typed_page ?(build=default_build) (typed_page:'a) =
    let tab_label,menu_label,page = build typed_page in
    let real_pos = super#current_page in
      typed_page_list <- Util.list_map_i (fun i x -> if i = real_pos then typed_page else x) 0 typed_page_list;
      super#set_page ?tab_label ?menu_label page

  method remove_page index =
    typed_page_list <- Util.list_filter_i (fun i x -> i <> index) typed_page_list;
    super#remove_page index

  method get_nth_typed_page i =
    List.nth typed_page_list i

  method typed_page_num p =
    Util.list_index0 p typed_page_list

  method pages = typed_page_list
end

let create build =
  GtkPack.Notebook.make_params []
    ~cont:(GContainer.pack_container
             ~create:(fun pl ->
                        let nb = GtkPack.Notebook.create pl in
                         (new typed_notebook build nb)))

