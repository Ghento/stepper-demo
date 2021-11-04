class Recipe{

  final String title;
  final int prepTime;
  final int serving;
  final List<Instruction> instruction;

  Recipe(this.title, this.prepTime, this.serving, this.instruction);
}

class Instruction {
  final int step;
  final String description;
  final int duration;

  Instruction(this.step, this.description, this.duration);
}