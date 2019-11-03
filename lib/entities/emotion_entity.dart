class DetectResult {
  final Map<String, double> emotion;
  final int timestamp;

  DetectResult(this.emotion, this.timestamp);
}


class EmotionData {
  final DetectResult result;

  EmotionData(this.result);

  static toSnapShot(DetectResult result){

    return {
        'emotion': result.emotion,
        'timestamp': result.timestamp,
      };
  }
}
