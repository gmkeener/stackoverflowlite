class ResponseModel {
  int? _statusCode;
  String? _message;
  dynamic _content;

  int? get statusCode => _statusCode;
  String? get message => _message;
  dynamic get content => _content;


  ResponseModel.fullConstructor(int statusCode, String message, dynamic content) {
    this._content = content;
    this._statusCode = statusCode;
    this._message = message;
  }

  ResponseModel.codeConstructor(int statusCode) {
    this._statusCode = statusCode;
  }

  ResponseModel.codeContentConstructor(int? statusCode, dynamic content) {
    this._content = content;
    this._statusCode = statusCode;
  }
}
