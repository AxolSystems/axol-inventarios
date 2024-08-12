class ObjectRelation {
  final String newIdParentObject;
  final String oldIdParentObject;
  final String idChildObject;

  ObjectRelation({
    required this.idChildObject,
    required this.newIdParentObject,
    required this.oldIdParentObject,
  });

  static List<String> listParent(List<ObjectRelation> objectList) {
    List<String> list = [];
    for (ObjectRelation obj in objectList) {
      if (!list.contains(obj.newIdParentObject)) {
        list.add(obj.newIdParentObject);
      }
      if (!list.contains(obj.oldIdParentObject)) {
        list.add(obj.oldIdParentObject);
      }
    }
    return list;
  }
}
