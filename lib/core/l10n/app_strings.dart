class AppStrings {
  const AppStrings(this.lang);

  final String lang;
  bool get isKh => lang == 'kh';

  // Navigation
  String get navHome => isKh ? 'ផ្ទះ' : 'Home';
  String get navMap => isKh ? 'ផែនទី' : 'Map';
  String get navContacts => isKh ? 'ទំនាក់ទំនង' : 'Contacts';
  String get navFirstAid => isKh ? 'គ្រោះថ្នាក់' : 'First Aid';

  // Contacts screen
  String get contactsTitle => isKh ? 'ទំនាក់ទំនងបន្ទាន់' : 'Emergency Contacts';
  String get contactsEmpty => isKh ? 'មិនទាន់មានទំនាក់ទំនងបន្ទាន់' : 'No emergency contacts yet';
  String get contactsEmptySub => isKh
      ? 'បន្ថែមមនុស្សដែលត្រូវទទួលការជូនដំណឹងក្នុងភាពបន្ទាន់'
      : 'Add people who should be notified\nin an emergency.';
  String get contactsAdd => isKh ? 'បន្ថែមទំនាក់ទំនង' : 'Add Contact';
  String get contactsEdit => isKh ? 'កែទំនាក់ទំនង' : 'Edit Contact';
  String get contactsAddTitle => isKh ? 'បន្ថែមទំនាក់ទំនងបន្ទាន់' : 'Add Emergency Contact';
  String get contactsRemoveTitle => isKh ? 'លុបទំនាក់ទំនង' : 'Remove Contact';
  String get contactsRemoveMsg => isKh ? 'លុបចេញពីទំនាក់ទំនងបន្ទាន់?' : 'Remove from emergency contacts?';
  String get contactsFailedLoad => isKh ? 'បរាជ័យក្នុងការផ្ទុកទំនាក់ទំនង' : 'Failed to load contacts';
  String get fieldName => isKh ? 'ឈ្មោះពេញ' : 'Full Name';
  String get fieldPhone => isKh ? 'លេខទូរស័ព្ទ' : 'Phone Number';
  String get fieldRelationship => isKh ? 'ទំនាក់ទំនង (ស្រេចចិត្ត)' : 'Relationship (optional)';
  String get save => isKh ? 'រក្សាទុក' : 'Save Contact';
  String get saveChanges => isKh ? 'រក្សាការផ្លាស់ប្ដូរ' : 'Save Changes';

  // Booking screen
  String get bookingTitle => isKh ? 'ការកក់របស់ខ្ញុំ' : 'My Bookings';
  String get bookingEmpty => isKh ? 'មិនទាន់មានការកក់' : 'No bookings yet';
  String get bookingEmptySub => isKh
      ? 'ចុចប៊ូតុងខាងក្រោមដើម្បីកក់សេវាបន្ទាន់'
      : 'Tap the button below to book\nan emergency service.';
  String get bookingNew => isKh ? 'ការកក់ថ្មី' : 'New Booking';
  String get bookingNewTitle => isKh ? 'ការកក់ថ្មី' : 'New Booking';
  String get bookingConfirm => isKh ? 'បញ្ជាក់ការកក់' : 'Confirm Booking';
  String get bookingServiceId => isKh ? 'លេខសម្គាល់សេវា' : 'Service ID';
  String get bookingNotes => isKh ? 'កំណត់ចំណាំ (ស្រេចចិត្ត)' : 'Notes (optional)';
  String get bookingFailedLoad => isKh ? 'បរាជ័យក្នុងការផ្ទុកការកក់' : 'Failed to load bookings';
  String get bookingFailedCreate => isKh ? 'បរាជ័យក្នុងការបង្កើតការកក់' : 'Failed to create booking';
  String get statusPending => isKh ? 'កំពុងរង់ចាំ' : 'Pending';
  String get statusConfirmed => isKh ? 'បានបញ្ជាក់' : 'Confirmed';
  String get statusCancelled => isKh ? 'បានបោះបង់' : 'Cancelled';

  // Reviews screen
  String get reviewsTitle => isKh ? 'មតិ' : 'Reviews';
  String get reviewsEmpty => isKh ? 'មិនទាន់មានមតិ' : 'No reviews yet';
  String get reviewsEmptySub => isKh ? 'ក្លាយជាអ្នកដំបូងបញ្ចេញមតិ' : 'Be the first to leave a review.';
  String get reviewsWrite => isKh ? 'សរសេរមតិ' : 'Write Review';
  String get reviewsWriteTitle => isKh ? 'សរសេរមតិ' : 'Write a Review';
  String get reviewsSubmit => isKh ? 'ដាក់ស្នើ' : 'Submit Review';
  String get reviewsFailedLoad => isKh ? 'បរាជ័យក្នុងការផ្ទុកមតិ' : 'Failed to load reviews';
  String get reviewsFailedSubmit => isKh ? 'បរាជ័យក្នុងការដាក់ស្នើ' : 'Failed to submit review';
  String get fieldYourName => isKh ? 'ឈ្មោះរបស់អ្នក' : 'Your Name';
  String get fieldComment => isKh ? 'មតិ' : 'Comment';
  String get fieldRating => isKh ? 'ការវាយតម្លៃ' : 'Rating';
  String get reviews => isKh ? 'មតិ' : 'review';
  String get reviewsPlural => isKh ? 'មតិ' : 'reviews';

  // Common
  String get retry => isKh ? 'ព្យាយាមម្តងទៀត' : 'Retry';
  String get cancel => isKh ? 'បោះបង់' : 'Cancel';
  String get remove => isKh ? 'លុប' : 'Remove';
  String get required => isKh ? 'ចាំបាច់' : 'Required';
}
