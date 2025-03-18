String baseUrl(bool isProduction) {
  return isProduction ? prodUrl : connUrl;
}

String connUrl = "https://api.nitroserve.co/api/v1";
String prodUrl = "https://nlp-tracker.herokuapp.com/api/v1";
// "https://api.nitroserve.co/api/v1";

// String apiGateWay =
//     "https://dev.ai.gateway.cliveai.com/dev/api/v4/chat-clive-stream";

// chatClive
// String devApiGateWay =
//     "https://dev.ai.gateway.cliveai.com/dev/api/v4/chat-clive";


