enum TileInteractionType {
  none,
  navigation,
  bottomSheet,
  popupMenu,
  expandable,
}

Map<TileInteractionType, List<String>> InteractionMappings = {
  TileInteractionType.none: [''],
  TileInteractionType.navigation: ['MLTEXT'],
  TileInteractionType.bottomSheet: ['PRJSS','RSRSS', 'TSKSS','REQSS','ROLEPS','INT','FLOAT','USS', 'TAGS','EMAIL','URL','CHGRP','RDGRP','COLPICK','LABL','DDSS','DDMS','UMS','RTFRM'],
  TileInteractionType.popupMenu: ['CHK','BLSTS'],
  TileInteractionType.expandable: ['INT']
};

TileInteractionType getInteractionType(String fieldType) {
  for (final entry in InteractionMappings.entries) {
    if (entry.value.contains(fieldType)) return entry.key;
  }
  return TileInteractionType.none;
}