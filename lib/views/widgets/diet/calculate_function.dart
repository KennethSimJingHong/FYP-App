import 'package:healthy_lifestyle_app/models/user.dart';

leanFactor(String gender, int age){
    if(gender == "male"){
      if(age >= 10 && age <= 14)
      return 1.0;
      if(age >= 15 && age <= 20)
      return 0.95;
      if(age >= 21 && age <= 28)
      return 0.90;
      if(age > 28)
      return 0.85;
    }else{
      if(age >= 14 && age <= 18)
      return 1.0;
      if(age >= 19 && age <= 28)
      return 0.95;
      if(age >= 29 && age <= 38)
      return 0.90;
      if(age > 38)
      return 0.85;
    }
  }

  exerciseLevel(String exercise){
    if(exercise == 'Very Light (< 1 exercsise)')
    return 1.3;
    if(exercise == 'Light (1-2 exercises)')
    return 1.55;
    if(exercise == 'Moderate (3-4 exercises)')
    return 1.65;
    if(exercise == 'Heavy (5-6 exercises)')
    return 1.80;
    if(exercise == 'Very Heavy (> 6 exercises)')
    return 2.00;

  }

  double calculateCalorie(User user){
    double val = leanFactor(user.gender, user.age);
    double stats = user.weight * (user.gender == "male" ? 1 : 0.9) * 24 * val;
    double exercise = exerciseLevel(user.exerciseLevel);
    double totalCal = (stats * exercise).roundToDouble();
    return totalCal;
  }

  double calculateHydration(User user){
    double dailyMustWater = user.weight / 30 * 1000;
    double addOnWaterAmt = user.exerciseDuration / 30 * 350;
    double totalWater = (dailyMustWater + addOnWaterAmt).roundToDouble();
    return totalWater;
  }