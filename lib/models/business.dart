
class BusinessProfile {
  final String logo;
  final String name;
  final String email;
  final String contact;
  final String address;
  final String description;
  final List<SocialProfile> socialProfiles;

  BusinessProfile({
    required this.logo,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.description,
    required this.socialProfiles,    
  });
}


class SocialProfile {
  final String id;  
  final SocialMedia socialMedia;
  final String account;
  final String link;

  SocialProfile({
    required this.id,
    required this.socialMedia,
    required this.account,
    required this.link,
  });
}


class SocialMedia {
  final String id;
  final String media; 
  final String mediaIcon;  
  SocialMedia({
    required this.id,
    required this.media,
    required this.mediaIcon,
  });
}
