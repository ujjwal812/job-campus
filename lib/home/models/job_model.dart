class JobModel {
  final String title;
  final String company;
  final String location;
  final String salary;
  final String type;
  final String category;
  final String logoText;
  final int logoColor;
  final bool isFeatured;
  final String experience;
  final String posted;
  final String description;
  final List<String> responsibilities;
  final List<String> requirements;
  final List<String> skills;
  final String aboutCompany;
  final String industry;

  const JobModel({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.category,
    required this.logoText,
    required this.logoColor,
    this.isFeatured = false,
    this.experience = '0–2 Years',
    this.posted = 'Recently',
    this.description = '',
    this.responsibilities = const [],
    this.requirements = const [],
    this.skills = const [],
    this.aboutCompany = '',
    this.industry = 'Technology & Software',
  });
}
