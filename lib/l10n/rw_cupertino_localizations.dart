import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// A custom CupertinoLocalizations for Kinyarwanda (`rw`).
class KinyarwandaCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const KinyarwandaCupertinoLocalizations();

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _KinyarwandaCupertinoLocalizationsDelegate();

  @override
  String datePickerHourSemanticsLabel(int hour) => '$hour amasaha';

  @override
  String datePickerMinuteSemanticsLabel(int minute) => '$minute iminota';

  String get datePickerDateOrderString => 'dmy';

  String get datePickerDateTimeOrderString => 'date_time_dayPeriod';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get todayLabel => 'Uyu munsi';

  @override
  String get alertDialogLabel => 'Ikitonderwa';

  String get timerPickerHourLabelOne => 'isaha';

  String get timerPickerHourLabelOther => 'amasaha';

  String get timerPickerMinuteLabelOne => 'umunota';

  String get timerPickerMinuteLabelOther => 'iminota';

  String get timerPickerSecondLabelOne => 'isegonda';

  String get timerPickerSecondLabelOther => 'amasegonda';

  @override
  String get cutButtonLabel => 'Kata';

  @override
  String get copyButtonLabel => 'Kopiya';

  @override
  String get pasteButtonLabel => 'Omerera';

  @override
  String get selectAllButtonLabel => 'Hitamo byose';

  @override
  String get searchTextFieldPlaceholderLabel => 'Shaka';

  @override
  String get modalBarrierDismissLabel => 'Kuvaho';
}

class _KinyarwandaCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _KinyarwandaCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'rw';

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
      const KinyarwandaCupertinoLocalizations(),
    );
  }

  @override
  bool shouldReload(_KinyarwandaCupertinoLocalizationsDelegate old) => false;
}
