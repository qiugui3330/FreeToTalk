// Importing necessary libraries and modules
import 'package:chatgpt_course/models/models_model.dart';
import 'package:chatgpt_course/services/api_service.dart';
import 'package:flutter/cupertino.dart';

// Defining a ModelsProvider class that extends ChangeNotifier
class ModelsProvider with ChangeNotifier {
  // Defining a property to store the current model
  String currentModel = "gpt-3.5-turbo-0301";

  // Defining a getter to get the current model
  String get getCurrentModel {
    return currentModel;
  }

  // Defining a method to set the current model
  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  // Defining a list to store models
  List<ModelsModel> modelsList = [];

  // Defining a getter to get the models list
  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  // Defining a method to get all models
  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
