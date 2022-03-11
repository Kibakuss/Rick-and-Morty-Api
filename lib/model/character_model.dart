class Character {
  final Map info;
  final List<Results> results;
  Character({
    required this.info,
    required this.results,
  });

   factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      info: json['info'],
      //results: json['results'],
      results: List<Results>.from(json["results"].map((x) => Results.fromJson(x))),
    );
  }
}




class Info {
  int count;
  int pages;
  String next;
  String prev;

  Info({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });
  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'],
      pages: json['pages'],
      next: json['next'],
      prev: json['prev'],

      
    );
  }
  }


class Results {

  final Map location;
  final Map origin;
  final String gender;
  final String image;
  final String name;
  final String species;
  final String status;
  final int id;
  

 
  Results(
      {
      required this.gender,
      required this.id,
      required this.image,
      required this.location,
      required this.name,
      required this.origin,
      required this.species,
      required this.status
      });

  Results.fromJson(Map<String, dynamic> json)
      : gender = json['gender'],
        id = json['id'],
        image = json['image'],
        location = json['location'],
        name = json['name'],
        origin = json['origin'],
        species = json['species'],
        status = json['status'];

}



