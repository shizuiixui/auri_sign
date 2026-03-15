/// FSL (Finger Spelling Language) Mapper
/// Maps gesture detections to FSL alphabet, common words, and phrases
class FSLMapper {
  // FSL alphabet mapping
  static const Map<String, String> fslAlphabet = {
    'A': 'Closed hand, thumb pointing up',
    'B': 'Flat hand, fingers extended, thumb folded',
    'C': 'Hand curved in C shape',
    'D': 'Fingers together, thumb pointing to the side',
    'E': 'Hand curved, fingers bent, thumb against palm',
    'F': 'Thumb and index finger forming circle',
    'G': 'Index and middle finger extended, curved in G shape',
    'H': 'Index and middle finger extended side by side',
    'I': 'Pinky finger extended, other fingers curled',
    'J': 'Pinky finger extended and curved like J',
    'K': 'Index and middle finger extended, thumb pointing up',
    'L': 'Thumb and index finger forming L shape',
    'M': 'Three fingers folded across palm, thumb hidden',
    'N': 'Two fingers folded across palm, thumb hidden',
    'O': 'All fingers and thumb forming circle',
    'P': 'Index and middle finger forming P shape',
    'Q': 'Index and middle finger bent, thumb pointing down',
    'R': 'Index and middle finger crossed',
    'S': 'Hand in fist with thumb across fingers',
    'T': 'Thumb between index and middle finger',
    'U': 'Index and middle finger extended and together',
    'V': 'Index and middle finger separated in V shape',
    'W': 'Index, middle, and ring finger extended in W shape',
    'X': 'Index finger bent in X shape',
    'Y': 'Thumb and pinky finger extended',
    'Z': 'Index finger tracing Z shape',
  };

  // Common FSL words mapping
  static const Map<String, String> commonWords = {
    'HELLO': 'Index fingers pointing from ears, moving outward',
    'GOODBYE': 'Open hand moving side to side',
    'THANK_YOU': 'Open hand moving from mouth to recipient',
    'YES': 'Fist moving up and down',
    'NO': 'Index and middle finger moving side to side',
    'PLEASE': 'Open hand in circular motion on chest',
    'SORRY': 'Fist hand moving in circles on chest',
    'LOVE': 'Both hands crossed over chest',
    'HELP': 'One hand supporting the fist of other hand',
    'MORE': 'Fingertips touching, hands coming together',
  };

  /// Convert detected gesture to FSL description
  static String gestureToFSL(String gesture) {
    if (gesture.isEmpty || gesture == 'Unknown') {
      return 'No gesture detected';
    }

    // Check if it's a letter
    if (fslAlphabet.containsKey(gesture)) {
      return '$gesture: ${fslAlphabet[gesture]!}';
    }

    // Check if it's a word
    if (commonWords.containsKey(gesture)) {
      return '$gesture - ${commonWords[gesture]!}';
    }

    return gesture;
  }

  /// Build text from sequential gesture detections
  static String buildText(List<String> detectedGestures) {
    List<String> chars = [];

    for (String gesture in detectedGestures) {
      if (gesture == 'Space') {
        chars.add(' ');
      } else if (gesture == 'Delete') {
        if (chars.isNotEmpty) {
          chars.removeLast();
        }
      } else if (gesture != 'Unknown' && gesture != 'Error') {
        chars.add(gesture);
      }
    }

    return chars.join('');
  }

  /// Get confidence level description
  static String getConfidenceDescription(double confidence) {
    if (confidence >= 0.9) return 'Very High';
    if (confidence >= 0.7) return 'High';
    if (confidence >= 0.5) return 'Medium';
    if (confidence >= 0.3) return 'Low';
    return 'Very Low';
  }

  /// Get common FSL phrases
  static List<String> getCommonPhrases() {
    return [
      'HELLO',
      'GOODBYE',
      'THANK_YOU',
      'PLEASE',
      'HELP',
      'YES',
      'NO',
      'MORE',
    ];
  }

  /// Get FSL alphabet as list
  static List<String> getAlphabet() {
    return fslAlphabet.keys.toList();
  }
}
