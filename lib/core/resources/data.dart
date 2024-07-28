class AppData {
  static const List<String> packagesServices = [
    'Psychology',
    'Saadhna',
    'Astrology',
    'Spirituality',
    'Meditation',
    'Healing',
    'Pandits',
    'Therapy',
    'Tarro Card',
  ];

  static const List<Map<String, dynamic>> contactItems = [
    {
      'imagePath': 'assets/icons/headphone.svg',
      'headText': 'Customer Service',
      'discText': 'contact@paratalks.in',
      'link': "contact@paratalks.in",
      'isMail': true,
    },
    {
      'imagePath': 'assets/icons/linked_in.svg',
      'headText': 'Linkedin',
      'discText': 'Connect with us on Linkedin.',
      'link': "https://www.linkedin.com/company/paratalks/mycompany/",
      'isMail': false,
    },
    {
      'imagePath': 'assets/icons/global.svg',
      'headText': 'Website',
      'discText': 'Visit our website.',
      'link': "https://www.paratalks.in/",
      'isMail': false,
    },
  ];

  static const String userDefaultImage =
      'https://e7.pngegg.com/pngimages/442/17/png-clipart-computer-icons-user-profile-male-user-heroes-head.png';
}
