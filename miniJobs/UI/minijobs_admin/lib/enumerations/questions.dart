enum Questions {
  workingHours,
  payment,
  additionalPayment,
}

// Map to associate descriptions with enum values
final Map<Questions, String> questionDescriptions = {
  Questions.workingHours: "Koje je radno vrijeme posla?",
  Questions.payment: "Nacin placanja?",
  Questions.additionalPayment: "Da li placate?",
};
