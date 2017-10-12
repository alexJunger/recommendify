void calculate_coconcurrent(char *item_id, int itemCount, struct cc_item *cc_items, int cc_items_size){
  int j;

  for(j = 0; j < cc_items_size; j++){
    cc_items[j].similarity = (float)cc_items[j].coconcurrency_count;
  }  
}
