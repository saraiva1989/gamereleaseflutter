import 'dart:convert';

class GamesModel {
  String error;
  int quantidade;
  String next;
  String previus;
  List<Retorno> retorno;

  GamesModel(
      {this.error, this.quantidade, this.next, this.previus, this.retorno});

    factory GamesModel.fromJson(Map<String, dynamic> parsedJson) {
    var retornoRetorno = parsedJson['retorno'] as List;
    List<Retorno> retornoList = List<Retorno>();
    if (retornoRetorno != null)
      retornoList = retornoRetorno.map((i) => Retorno.fromJson(i)).toList();

    return GamesModel(
        error: parsedJson['error'], 
        quantidade: parsedJson['quantidade'], 
        next: parsedJson['next'], 
        previus: parsedJson['previus'], 
        retorno: retornoList
    );
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
  double score;
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

  factory Retorno.fromJson(Map<String, dynamic> parsedJson) {
    var retornoGenero = parsedJson['generos'] as List;
    var retornoPlataforma = parsedJson['plataformas'] as List;
    var retornoLojas = parsedJson['lojas'] as List;
    var retornoFotos = parsedJson['fotos'] as List;
    List<Genero> generoList = retornoGenero.map((i) => Genero.fromJson(i)).toList();
    List<Plataforma> plataformaList = retornoPlataforma.map((i) => Plataforma.fromJson(i)).toList();
    List<Loja> lojaList = retornoLojas.map((i) => Loja.fromJson(i)).toList();
    List<Foto> fotoList = retornoFotos.map((i) => Foto.fromJson(i)).toList();

    return Retorno(
        id: parsedJson['id'], 
        nome: parsedJson['nome'],
        data: parsedJson['data'], 
        background: parsedJson['background'], 
        clip: parsedJson['clip'], 
        videoyoutube: parsedJson['videoyoutube'], 
        videoimagepreview: parsedJson['videoimagepreview'], 
        nota: parsedJson['nota'].toDouble(), 
        qtdvotacao: parsedJson['qtdvotacao'], 
        metacritic: parsedJson['metacritic'], 
        score: parsedJson['score'], 
        descricaohtml: parsedJson['descricaohtml'], 
        descricao: parsedJson['descricao'], 
        website: parsedJson['website'],
        developer: parsedJson['developer'],
        publishers: parsedJson['publishers'], 
        generos: generoList,
        plataformas: plataformaList,
        lojas: lojaList,
        fotos: fotoList,
        );
  }
}

class Genero {
  int id;
  String nome;

  Genero({this.id, this.nome});

  factory Genero.fromJson(Map<String, dynamic> parsedJson) {
    return Genero(id: parsedJson['id'], nome: parsedJson['nome']);
  }

  String retornaString(List<Genero> genero){
    String retorno = "";
    if (genero.length > 0){
      for (var item in genero){
        
        genero.last.id != item.id ? retorno += "${item.nome}, " : retorno += "${item.nome}";
      }
      return retorno;
    }
  }
}

class Foto {
  int id;
  String url;

  Foto({this.id, this.url});

  factory Foto.fromJson(Map<String, dynamic> parsedJson) {
    return Foto(id: parsedJson['id'], url: parsedJson['url']);
  }
}

class Loja {
  int id;
  String nome;
  String url;

  Loja({this.id, this.nome, this.url});

  factory Loja.fromJson(Map<String, dynamic> parsedJson) {
    return Loja(id: parsedJson['id'], nome: parsedJson['nome'], url: parsedJson['url']);
  }
}

class Plataforma {
  int id;
  String nome;

  Plataforma({this.id, this.nome});

  factory Plataforma.fromJson(Map<String, dynamic> parsedJson) {
    return Plataforma(id: parsedJson['id'], nome: parsedJson['nome']);
  }
}
