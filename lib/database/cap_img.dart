class CapImg {
  int id;
  String path;

  CapImg({
    this.id,
    this.path,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.path;
    return data;
  }

  CapImg.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.path = json['path'];
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, path: $path}';
  }
}
