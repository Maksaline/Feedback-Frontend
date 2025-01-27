class CategoryService {
  static final List<String> states = [
    'Software Development',
    'IT Services',
    'Cloud Services',
    'Clinics',
    'Hospital',
    'Telemedicine',
    'Diagnostic Center',
    'Online Learning Platforms',
    'Test Preparation Services',
    'Tutoring Providers',
    'Delivery Services',
    'Warehousing',
    'Web Developer',
    'Banking',
    'Finance',
    'Research',
    'Graphic Design',
    'Civil Services',
    'Electrical Services',
    'Mechanical Services',
    'Aeronautical Services',
    'E-commerce',
    'Grocery',
    'Fashion',
    'Clothing',
    'Education',
    'University',
    'College',
    'School',
    'ISP',
    'Restaurant',
    'Law Firm',
    'Cafe',
    'Park',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}