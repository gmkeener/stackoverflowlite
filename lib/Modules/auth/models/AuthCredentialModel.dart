class AuthCredentialModel {
  String? accessToken;
  String? expiresIn;
  String? tokenType;
  String? refreshToken;
  String? idToken;
  String? userId;
  String? projectId;

  AuthCredentialModel(
      {this.accessToken,
      this.expiresIn,
      this.tokenType,
      this.refreshToken,
      this.idToken,
      this.userId,
      this.projectId});

  AuthCredentialModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    idToken = json['id_token'];
    userId = json['user_id'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    data['token_type'] = this.tokenType;
    data['refresh_token'] = this.refreshToken;
    data['id_token'] = this.idToken;
    data['user_id'] = this.userId;
    data['project_id'] = this.projectId;
    return data;
  }
}