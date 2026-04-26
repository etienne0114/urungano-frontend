import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A custom MaterialLocalizations for Kinyarwanda (`rw`).
///
/// Flutter does not ship Material strings for the `rw` locale.
/// Rather than attempting to override every single abstract member of
/// [GlobalMaterialLocalizations] (which changes across Flutter releases),
/// we extend [DefaultMaterialLocalizations] which already supplies
/// English defaults for all members, and override only the strings
/// we want translated.
class KinyarwandaMaterialLocalizations extends DefaultMaterialLocalizations {
  const KinyarwandaMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _KinyarwandaMaterialLocalizationsDelegate();

  @override
  String get alertDialogLabel => 'Ikitonderwa';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get backButtonTooltip => 'Subira inyuma';

  @override
  String get cancelButtonLabel => 'REKA';

  @override
  String get closeButtonLabel => 'FUNGA';

  @override
  String get closeButtonTooltip => 'Funga';

  String get collapsedIconTapTargetLabel => 'Yagura';

  @override
  String get continueButtonLabel => 'KOMEZA';

  @override
  String get copyButtonLabel => 'KOPIYA';

  @override
  String get cutButtonLabel => 'KATA';

  @override
  String get deleteButtonTooltip => 'Siba';

  @override
  String get dialogLabel => 'Ibiganiro';

  @override
  String get drawerLabel => 'Menu';

  String get expandedIconTapTargetLabel => 'Gufunga';

  @override
  String get firstPageTooltip => 'Urupapuro rwa mbere';

  @override
  String get hideAccountsLabel => 'Hisha konti';

  @override
  String get lastPageTooltip => 'Urupapuro rwa nyuma';

  @override
  String get licensesPageTitle => 'Impushya';

  @override
  String get modalBarrierDismissLabel => 'Kuvaho';

  @override
  String get nextMonthTooltip => 'Ukwezi gutaha';

  @override
  String get nextPageTooltip => 'Urupapuro rukurikira';

  @override
  String get okButtonLabel => 'Yego';

  @override
  String get pasteButtonLabel => 'OMERERA';

  @override
  String get popupMenuLabel => 'Menu ya popup';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'Ukwezi gushize';

  @override
  String get previousPageTooltip => 'Urupapuro rubanza';

  @override
  String get refreshIndicatorSemanticLabel => 'Ivugurura';

  @override
  String get reorderItemDown => 'Imura hasi';

  @override
  String get reorderItemLeft => 'Imura iburyo';

  @override
  String get reorderItemRight => 'Imura ibumoso';

  @override
  String get reorderItemToEnd => 'Imura ku ndunduro';

  @override
  String get reorderItemToStart => 'Imura mu ntangiriro';

  @override
  String get reorderItemUp => 'Imura hejuru';

  @override
  String get rowsPerPageTitle => 'Imirongo kuri buri rupapuro:';

  @override
  String get saveButtonLabel => 'BIKA';

  @override
  String get searchFieldLabel => 'Shaka';

  @override
  String get selectAllButtonLabel => 'HITAMO BYOSE';

  @override
  String get selectYearSemanticsLabel => 'Hitamo umwaka';

  @override
  String get showAccountsLabel => 'Erekana konti';

  @override
  String get showMenuTooltip => 'Erekana menu';

  @override
  String get signedInLabel => 'Winjiye';

  @override
  String get timePickerHourLabel => 'Isaha';

  @override
  String get timePickerMinuteLabel => 'Umunota';

  @override
  String get viewLicensesButtonLabel => 'REBA IMPUSHYA';

  @override
  String get calendarModeButtonLabel => 'Hindura kuri kalendari';

  @override
  String get dateHelpText => 'mm/dd/yyyy';

  @override
  String get dateInputLabel => 'Injiza itariki';

  @override
  String get dateOutOfRangeLabel => 'Itariki iri hanze y\'urugero.';

  @override
  String get datePickerHelpText => 'HITAMO ITARIKI';

  @override
  String get dateRangeEndLabel => 'Itariki isoza';

  @override
  String get dateRangePickerHelpText => 'HITAMO URUGERO RW\'ITARIKI';

  @override
  String get dateRangeStartLabel => 'Itariki itangira';

  @override
  String get dateSeparator => '/';

  @override
  String get dialModeButtonLabel => 'Hindura ku buryo bwa dial';

  @override
  String get inputDateModeButtonLabel => 'Hindura ku buryo bwo kwandika';

  @override
  String get inputTimeModeButtonLabel => 'Hindura ku buryo bwo kwandika igihe';

  @override
  String get invalidDateFormatLabel => 'Imiterere y\'itariki ntabwo ari yo.';

  @override
  String get invalidDateRangeLabel => 'Urugero rw\'itariki ntabwo ari rwo.';

  @override
  String get invalidTimeLabel => 'Igihe ntabwo ari cyo.';

  @override
  String get moreButtonTooltip => 'Ibindi';

  @override
  String get timePickerDialHelpText => 'HITAMO IGIHE';

  @override
  String get timePickerHourModeAnnouncement => 'Hitamo amasaha';

  @override
  String get timePickerInputHelpText => 'INJIZA IGIHE';

  @override
  String get timePickerMinuteModeAnnouncement => 'Hitamo iminota';

  @override
  String get unspecifiedDate => 'Itariki';

  @override
  String get unspecifiedDateRange => 'Urugero rw\'itariki';
}

class _KinyarwandaMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _KinyarwandaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'rw';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture<MaterialLocalizations>(
      const KinyarwandaMaterialLocalizations(),
    );
  }

  @override
  bool shouldReload(_KinyarwandaMaterialLocalizationsDelegate old) => false;
}
