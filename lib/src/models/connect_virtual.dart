import '../core/json_utils.dart';

/// Connect authorize-link request parameters.
class ConnectAuthorizeRequest {
  final String clientId;
  final String redirectUri;
  final String mode;
  final String? scope;
  final String? webhookUrl;
  final String? webhookSecret;

  const ConnectAuthorizeRequest({
    required this.clientId,
    required this.redirectUri,
    required this.mode,
    this.scope,
    this.webhookUrl,
    this.webhookSecret,
  });

  Map<String, String> toQuery() => {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'mode': mode,
        if (scope != null) 'scope': scope!,
        if (webhookUrl != null) 'wh_url': webhookUrl!,
        if (webhookSecret != null) 'wh_secret': webhookSecret!,
      };
}

class ConnectAuthorizeResponse {
  final String? authorizeUrl;
  final Map<String, dynamic> raw;

  const ConnectAuthorizeResponse({this.authorizeUrl, required this.raw});

  factory ConnectAuthorizeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    String? url;
    if (data is String) {
      url = data;
    } else if (data is Map) {
      url = data['url']?.toString() ??
          data['authorize_url']?.toString() ??
          data['link']?.toString();
    }
    url ??= json['url']?.toString() ??
        json['authorize_url']?.toString() ??
        json['link']?.toString();

    return ConnectAuthorizeResponse(authorizeUrl: url, raw: json);
  }
}

class ConnectUserResponse {
  final Map<String, dynamic> raw;
  final String? status;
  final String? message;
  final dynamic data;

  const ConnectUserResponse({
    required this.raw,
    this.status,
    this.message,
    this.data,
  });

  factory ConnectUserResponse.fromJson(Map<String, dynamic> json) {
    return ConnectUserResponse(
      raw: json,
      status: JsonUtils.asString(json['status']),
      message: JsonUtils.asString(json['message']),
      data: json['data'] ?? json,
    );
  }
}

/// Virtual account customer create/update body.
class VirtualCustomerRequest {
  final String email;
  final String firstName;
  final String lastName;

  const VirtualCustomerRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
      };
}

class VirtualCustomerResponse {
  final String? status;
  final String? message;
  final Map<String, dynamic> data;
  final Map<String, dynamic> raw;

  const VirtualCustomerResponse({
    this.status,
    this.message,
    required this.data,
    required this.raw,
  });

  factory VirtualCustomerResponse.fromJson(Map<String, dynamic> json) {
    return VirtualCustomerResponse(
      status: JsonUtils.asString(json['status']),
      message: JsonUtils.asString(json['message']),
      data: JsonUtils.asMap(json['data']) ?? json,
      raw: json,
    );
  }

  String? get id =>
      JsonUtils.asString(data['id']) ?? JsonUtils.asString(data['customer_id']);
}
