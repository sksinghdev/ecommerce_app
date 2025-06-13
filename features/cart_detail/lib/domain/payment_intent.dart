class PaymentIntent {
  final String clientSecret;

  PaymentIntent({required this.clientSecret});

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(clientSecret: json['clientSecret']);
  }
}
