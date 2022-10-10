class SignatureModel {
  final String id;
  final String name;
  final int counter;

  SignatureModel({required this.id, required this.name, required this.counter});

  factory SignatureModel.fromMap(Map<String, dynamic> model) {
    return SignatureModel(
      id: model['id'],
      name: model['name'],
      counter: model['counter'],
    );
  }
}
