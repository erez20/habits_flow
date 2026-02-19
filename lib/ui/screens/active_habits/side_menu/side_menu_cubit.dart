import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/shared/generate_backup_use_case.dart';
import 'package:habits_flow/domain/use_cases/shared/restore_backup_use_case.dart';
import 'side_menu_state.dart';
import 'package:share_plus/share_plus.dart'; // Share, XFile
import 'package:file_picker/file_picker.dart'; // FilePicker



class SideMenuCubit extends Cubit<SideMenuState> {
  final GenerateBackupUseCase generateBackupUseCase;
  final RestoreBackupUseCase restoreBackupUseCase;

  SideMenuCubit({
    required this.generateBackupUseCase,
    required this.restoreBackupUseCase,
  }) : super(SideMenuState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  void exportDb() async {
    final result = await generateBackupUseCase.exec(null);
    if (result.isSuccess) {
      final dbFile = (result as Success).data;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(dbFile.path)],
          subject: 'Backup',
        ),
      );
    }
  }

  Future<void> pickAndRestore() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, // or FileType.custom, allowedExtensions: ['sqlite']
    );

    if (result == null) return; // user cancelled

    final pickedFilePath = result.files.single.path!;
    restoreBackupUseCase.exec(pickedFilePath);
  }
}
