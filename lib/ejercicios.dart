// To parse this JSON data, do
//
//     final ejercicios = ejerciciosFromJson(jsonString);

import 'dart:convert';

List<Ejercicios> ejerciciosFromJson(String str) =>
    List<Ejercicios>.from(json.decode(str).map((x) => Ejercicios.fromJson(x)));

String ejerciciosToJson(List<Ejercicios> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ejercicios {
  final String name;
  final Type type;
  final String muscle;
  final String equipment;
  final Difficulty difficulty;
  final String instructions;

  Ejercicios({
    required this.name,
    required this.type,
    required this.muscle,
    required this.equipment,
    required this.difficulty,
    required this.instructions,
  });

  factory Ejercicios.fromJson(Map<String, dynamic> json) => Ejercicios(
        name: json["name"],
        type: typeValues.map[json["type"]]!,
        muscle: json["muscle"],
        equipment: json["equipment"],
        difficulty: difficultyValues.map[json["difficulty"]]!,
        instructions: json["instructions"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": typeValues.reverse[type],
        "muscle": muscle,
        "equipment": equipment,
        "difficulty": difficultyValues.reverse[difficulty],
        "instructions": instructions,
      };
}

enum Difficulty { BEGINNER, EXPERT, INTERMEDIATE }

final difficultyValues = EnumValues({
  "beginner": Difficulty.BEGINNER,
  "expert": Difficulty.EXPERT,
  "intermediate": Difficulty.INTERMEDIATE
});

enum Type { OLYMPIC_WEIGHTLIFTING, STRENGTH, STRETCHING }

final typeValues = EnumValues({
  "olympic_weightlifting": Type.OLYMPIC_WEIGHTLIFTING,
  "strength": Type.STRENGTH,
  "stretching": Type.STRETCHING
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
