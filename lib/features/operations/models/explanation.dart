/// خطوة في الشرح التفصيلي
class ExplanationStep {
  final String title;
  final String description;
  final String? visual;
  final bool isHighlighted;

  const ExplanationStep({
    required this.title,
    required this.description,
    this.visual,
    this.isHighlighted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'visual': visual,
      'isHighlighted': isHighlighted,
    };
  }

  factory ExplanationStep.fromMap(Map<String, dynamic> map) {
    return ExplanationStep(
      title: map['title'] as String,
      description: map['description'] as String,
      visual: map['visual'] as String?,
      isHighlighted: map['isHighlighted'] as bool? ?? false,
    );
  }
}

/// الشرح الكامل للعملية
class Explanation {
  final String result;
  final List<ExplanationStep> steps;
  final String? additionalInfo;

  const Explanation({
    required this.result,
    required this.steps,
    this.additionalInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result,
      'steps': steps.map((step) => step.toMap()).toList(),
      'additionalInfo': additionalInfo,
    };
  }

  factory Explanation.fromMap(Map<String, dynamic> map) {
    return Explanation(
      result: map['result'] as String,
      steps: (map['steps'] as List<dynamic>)
          .map((step) => ExplanationStep.fromMap(step as Map<String, dynamic>))
          .toList(),
      additionalInfo: map['additionalInfo'] as String?,
    );
  }
}
