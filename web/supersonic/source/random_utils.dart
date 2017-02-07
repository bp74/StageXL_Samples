part of supersonic;

class RandomUtils {

  static math.Random _random = new math.Random();

  static int getIntByRange(int min, int max) {

    if (max < min) {
      var tmp = min;
      min = max;
      max = tmp;
    }

    if (min == max) {
      return min;
    } else {
      return _random.nextInt(max - min + 1) + min;
    }
  }

  static num getNumberByRange (num min, num max) {

    if (max < min) {
      var tmp = min;
      min = max;
      max = tmp;
    }

    if (min == max) {
      return min;
    } else {
      return _random.nextDouble() * (max - min) + min;
    }
  }

  static bool getBooleanByProbability(num probability) {
    if (probability > 1) {
      probability = 1;
    } else if (probability < 0) {
      probability = 0;
    }
    return (_random.nextDouble() <= probability);
  }

  static Object getRandomEntryFromArray (List arr) {
    return arr[getIntByRange(0, arr.length - 1)];
  }

}
