part of jaguar_oauth2;

/// Links facebook with existing user account
class LinkFacebook extends Interceptor {
  final FacebookModelManager manager;

  LinkFacebook(this.manager);

  Future<FacebookUserModel> pre(Context ctx) async {
    oauth2.Client client = ctx.getInput(OAuth2Authorized);
    AuthorizationUser model = ctx.getInput(Authorizer);

    if (model is! FacebookUserModel) {
      throw new UnAuthorizedError();
    }

    final graph = new fb.GraphApi(client);
    final fields = new fb.UserFieldSelector()
      ..addBirthday()
      ..addAbout()
      ..addEmail()
      ..addName();
    final fb.UserResult resp = await graph.getMe(fields: fields);
    await manager.setFbInfo(model, resp.id, client.credentials.accessToken,
        client.credentials.refreshToken);
    final ret =
        await manager.fetchModelByAuthorizationId(model.authorizationId);
    if (ret == null) {
      throw new UnAuthorizedError();
    }
    return ret;
  }
}
