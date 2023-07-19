// Defining a ModelsModel class
class ModelsModel {
  // Defining properties for the class
  final String id;
  final int created;
  final String root;

  // Defining a constructor for the class
  ModelsModel({
    required this.id,
    required this.root,
    required this.created,
  });

  // Defining a factory method to create an instance of the class from a JSON object
  factory ModelsModel.fromJson(Map<String, dynamic> json) => ModelsModel(
    id: json["id"],
    root: json["root"],
    created: json["created"],
  );

  // Defining a method to create a list of ModelsModel from a list of JSON objects
  static List<ModelsModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) => ModelsModel.fromJson(data)).toList();
  }
}
