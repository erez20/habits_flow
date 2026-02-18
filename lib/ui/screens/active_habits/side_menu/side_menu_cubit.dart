
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/shared/generate_backup_use_case.dart';
import 'side_menu_state.dart';
import 'package:share_plus/share_plus.dart'; // Share, XFile


class SideMenuCubit extends Cubit<SideMenuState> {
  final GenerateBackupUseCase generateBackupUseCase;
  SideMenuCubit({required this.generateBackupUseCase}) : super(SideMenuState.init()) {
    init();
  }

  void init() {
    // Initialize streams or domain listeners here
  }

  void exportDb() async{
    final result = await generateBackupUseCase.exec(null);
    if (result.isSuccess) {
      final dbFile = (result as Success).data;
      await SharePlus.instance.share(ShareParams(
        files: [XFile(dbFile.path)],
        subject: 'Backup',
      ),);
    }
  }
}
