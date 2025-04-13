import 'question_model.dart';

class CategoryModel {
  final String categoryName;
  final List<QuestionModel> questions;

  CategoryModel({required this.categoryName, required this.questions});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['category'] as String,
      questions: (json['questions'] as List)
          .map((item) => QuestionModel.fromJson(item))
          .toList(),
    );
  }
}
