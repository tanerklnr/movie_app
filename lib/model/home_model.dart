class HomeModel {
  String? title;
  String? year;
  String? rated;
  String? released;
  String? runtime;
  String? genre;
  String? director;
  String? writer;
  String? actors;
  String? plot;
  String? language;
  String? country;
  String? awards;
  String? poster;
  String? metascore;
  String? imdbRating;
  String? imdbVotes;
  String? imdbID;
  String? type;
  String? response;
  List<String>? images;

  HomeModel(
      {this.title,
        this.year,
        this.rated,
        this.released,
        this.runtime,
        this.genre,
        this.director,
        this.writer,
        this.actors,
        this.plot,
        this.language,
        this.country,
        this.awards,
        this.poster,
        this.metascore,
        this.imdbRating,
        this.imdbVotes,
        this.imdbID,
        this.type,
        this.response,
        this.images});

  HomeModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    year = json['year'];
    rated = json['rated'];
    released = json['released'];
    runtime = json['runtime'];
    genre = json['genre'];
    director = json['director'];
    writer = json['writer'];
    actors = json['actors'];
    plot = json['plot'];
    language = json['language'];
    country = json['Country'];
    awards = json['Awards'];
    poster = json['Poster'];
    metascore = json['Metascore'];
    imdbRating = json['imdbRating'];
    imdbVotes = json['imdbVotes'];
    imdbID = json['imdbID'];
    type = json['Type'];
    response = json['Response'];
    images = json['Images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['year'] = this.year;
    data['rated'] = this.rated;
    data['released'] = this.released;
    data['runtime'] = this.runtime;
    data['genre'] = this.genre;
    data['director'] = this.director;
    data['writer'] = this.writer;
    data['actors'] = this.actors;
    data['plot'] = this.plot;
    data['language'] = this.language;
    data['Country'] = this.country;
    data['Awards'] = this.awards;
    data['Poster'] = this.poster;
    data['Metascore'] = this.metascore;
    data['imdbRating'] = this.imdbRating;
    data['imdbVotes'] = this.imdbVotes;
    data['imdbID'] = this.imdbID;
    data['Type'] = this.type;
    data['Response'] = this.response;
    data['Images'] = this.images;
    return data;
  }
}
