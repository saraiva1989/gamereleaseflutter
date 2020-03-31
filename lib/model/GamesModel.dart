class GamesModel {
  String error;
  int quantidade;
  String next;
  String previous;
  List<Retorno> retorno;

  GamesModel(
      {this.error, this.quantidade, this.next, this.previous, this.retorno});

  GamesModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    quantidade = json['quantidade'];
    next = json['next'];
    previous = json['previous'];
    if (json['retorno'] != null) {
      retorno = new List<Retorno>();
      json['retorno'].forEach((v) {
        retorno.add(new Retorno.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['quantidade'] = this.quantidade;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.retorno != null) {
      data['retorno'] = this.retorno.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Retorno {
  int id;
  String nome;
  String data;
  String background;
  String clip;
  String videoyoutube;
  String videoimagepreview;
  double nota;
  int qtdvotacao;
  int metacritic;
  int score;
  String descricaohtml;
  String descricao;
  String website;
  String developer;
  String publishers;
  List<Plataforma> plataformas;
  List<Loja> lojas;
  List<Foto> fotos;
  List<Genero> generos;

  Retorno(
      {this.id,
      this.nome,
      this.data,
      this.background,
      this.clip,
      this.videoyoutube,
      this.videoimagepreview,
      this.nota,
      this.qtdvotacao,
      this.metacritic,
      this.score,
      this.descricaohtml,
      this.descricao,
      this.website,
      this.developer,
      this.publishers,
      this.plataformas,
      this.lojas,
      this.fotos,
      this.generos});

  Retorno.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    data = json['data'];
    background = json['background'];
    clip = json['clip'];
    videoyoutube = json['videoyoutube'];
    videoimagepreview = json['videoimagepreview'];
    nota = json['nota'].toDouble() ?? 0;
    qtdvotacao = json['qtdvotacao'];
    metacritic = json['metacritic'];
    score = json['score'];
    descricaohtml = json['descricaohtml'];
    descricao = json['descricao'];
    website = json['website'];
    developer = json['developer'];
    publishers = json['publishers'];
    if (json['plataformas'] != null) {
      plataformas = new List<Plataforma>();
      json['plataformas'].forEach((v) {
        plataformas.add(new Plataforma.fromJson(v));
      });
    }
    if (json['lojas'] != null) {
      lojas = new List<Loja>();
      json['lojas'].forEach((v) {
        lojas.add(new Loja.fromJson(v));
      });
    }
    if (json['fotos'] != null) {
      fotos = new List<Foto>();
      json['fotos'].forEach((v) {
        fotos.add(new Foto.fromJson(v));
      });
    }
    if (json['generos'] != null) {
      generos = new List<Genero>();
      json['generos'].forEach((v) {
        generos.add(new Genero.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['data'] = this.data;
    data['background'] = this.background;
    data['clip'] = this.clip;
    data['videoyoutube'] = this.videoyoutube;
    data['videoimagepreview'] = this.videoimagepreview;
    data['nota'] = this.nota;
    data['qtdvotacao'] = this.qtdvotacao;
    data['metacritic'] = this.metacritic;
    data['score'] = this.score;
    data['descricaohtml'] = this.descricaohtml;
    data['descricao'] = this.descricao;
    data['website'] = this.website;
    data['developer'] = this.developer;
    data['publishers'] = this.publishers;
    if (this.plataformas != null) {
      data['plataformas'] = this.plataformas.map((v) => v.toJson()).toList();
    }
    if (this.lojas != null) {
      data['lojas'] = this.lojas.map((v) => v.toJson()).toList();
    }
    if (this.fotos != null) {
      data['fotos'] = this.fotos.map((v) => v.toJson()).toList();
    }
    if (this.generos != null) {
      data['generos'] = this.generos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plataforma {
  int id;
  String nome;

  Plataforma({this.id, this.nome});

  Plataforma.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    return data;
  }
}

class Loja {
  int id;
  String nome;
  String url;

  Loja({this.id, this.nome, this.url});

  Loja.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['url'] = this.url;
    return data;
  }
}

class Foto {
  int id;
  String url;

  Foto({this.id, this.url});

  Foto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class Genero {
  int id;
  String nome;

  Genero({this.id, this.nome});

  Genero.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.nome;
    return data;
  }

  String retornaString(List<Genero> genero){
    String retorno = "";
    if (genero.length > 0){
      for (var item in genero){
        
        genero.last.id != item.id ? retorno += "${item.nome}, " : retorno += "${item.nome}";
      }
    }
    return retorno;
  }
}