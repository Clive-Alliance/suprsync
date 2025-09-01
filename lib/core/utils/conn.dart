String baseUrl(bool isProduction) {
  return isProduction ? prodUrl : connUrl;
}

String connUrl = "https://api.nitroserve.co/api/v1";
String prodUrl = "https://nlp-tracker.herokuapp.com/api/v1";
