class AutocompletePrediction {
  final String? description;
  final StructuredFormatting? structuredFormatting;
  final String? reference;
  final String? placeId;

  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.reference,
    this.placeId
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json){
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
         ? StructuredFormatting.fromJson(json['structured_formatting'])
         : null,
    );
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({
    this.mainText,
    this.secondaryText
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic>json){
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}