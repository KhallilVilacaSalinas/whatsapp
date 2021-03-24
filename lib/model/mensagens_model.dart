class MensagemUser {
  String _idUsuario;
  String _mensagem;
  String _urlImagem;

  String _tipo;
  String _data;

  MensagemUser();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUsuario": this.idUsuario,
      "mensagem": this.mensagem,
      "urlImagem": this.urlImagem,
      "tipo": this.tipo,
      "data": this.data,
    };
    return map;
  }

  get idUsuario => this._idUsuario;

  set idUsuario(value) => this._idUsuario = value;

  get mensagem => this._mensagem;

  set mensagem(value) => this._mensagem = value;

  get urlImagem => this._urlImagem;

  set urlImagem(String value) => this._urlImagem = value;

  get tipo => this._tipo;

  set tipo(value) => this._tipo = value;

  get data => this._data;

  set data(value) => this._data = value;
}
