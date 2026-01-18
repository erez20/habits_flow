import 'package:flutter_test/flutter_test.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';
import 'package:habits_flow/domain/entities/habit_entity.dart';
import 'package:habits_flow/domain/repos/group_repo.dart';
import 'package:habits_flow/domain/repos/habit_repo.dart';
import 'package:habits_flow/domain/responses/domain_error.dart';
import 'package:habits_flow/domain/responses/domain_response.dart';
import 'package:habits_flow/domain/use_cases/habit/add_habit_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_habit_use_case_test.mocks.dart'; // This file will be generated

@GenerateMocks([HabitRepo, GroupRepo])
void main() {
  setUpAll(() {
    provideDummy<DomainResponse<HabitEntity>>(const Success(
        HabitEntity(id: '', title: '', info: '', weight: 0, completionCount: 0)));
    provideDummy<DomainResponse<GroupEntity>>(const Success(
        GroupEntity(id: '', title: '', weight: 0, colorHex: '', habits: [])));
  });
  
  late AddHabitUseCase addHabitUseCase;
  late MockHabitRepo mockHabitRepo;
  late MockGroupRepo mockGroupRepo;

  setUp(() {
    mockHabitRepo = MockHabitRepo();
    mockGroupRepo = MockGroupRepo();
    addHabitUseCase = AddHabitUseCase(
      habitRepo: mockHabitRepo,
      groupRepo: mockGroupRepo,
    );
  });

  group('AddHabitUseCase', () {
    final tGroupId = 'groupId123';
    final tHabitTitle = 'Read a book';
    final tHabitWeight = 1;
    final tHabitInfo = 'Read for 30 minutes';
    final tHabit = HabitEntity(
      id: 'habitId123',
      title: tHabitTitle,
      weight: tHabitWeight,
      info: tHabitInfo,
      completionCount: 0,
    );

    final tGroup = GroupEntity(
      id: tGroupId,
      title: 'My Group',
      weight: 1,
      colorHex: '#FFFFFF',
      habits: [tHabit],
    );

    final tParams = AddHabitUseCaseParams(
      groupId: tGroupId,
      title: tHabitTitle,
      weight: tHabitWeight,
      info: tHabitInfo,
    );

    test('should successfully add a habit and assign it to a group', () async {
      // Arrange
      when(mockHabitRepo.createHabit(
        title: tHabitTitle,
        weight: tHabitWeight,
      )).thenAnswer((_) async => Success(tHabit));

      when(mockGroupRepo.addHabitToGroup(
        groupId: tGroupId,
        habit: tHabit,
      )).thenAnswer((_) async => Success(tGroup));

      // Act
      final result = await addHabitUseCase.exec(tParams);

      // Assert
      expect(result, isA<Success>());
      verify(mockHabitRepo.createHabit(
        title: tHabitTitle,
        weight: tHabitWeight,
      )).called(1);
      verify(mockGroupRepo.addHabitToGroup(
        groupId: tGroupId,
        habit: tHabit,
      )).called(1);
      verifyNoMoreInteractions(mockHabitRepo);
      verifyNoMoreInteractions(mockGroupRepo);
    });

    test('should return DomainError when habit creation fails', () async {
      // Arrange
      final tError = UnknownError('Failed to create habit');
      when(mockHabitRepo.createHabit(
        title: tHabitTitle,
        weight: tHabitWeight,
      )).thenAnswer((_) async => Failure(error: tError));

      // Act
      final result = await addHabitUseCase.exec(tParams);

      // Assert
      expect(result, isA<Failure>());
      expect((result as Failure).error, tError);
      verify(mockHabitRepo.createHabit(
        title: tHabitTitle,
        weight: tHabitWeight,
      )).called(1);
      verifyNoMoreInteractions(mockHabitRepo);
      verifyZeroInteractions(mockGroupRepo); // GroupRepo should not be called
    });

    test('should return DomainError when adding habit to group fails', () async {
      // Arrange
      final tError = UnknownError('Failed to add habit to group');
      when(mockHabitRepo.createHabit(
        title: tHabitTitle,
        weight: tHabitWeight,
      )).thenAnswer((_) async => Success(tHabit));

      when(mockGroupRepo.addHabitToGroup(
        groupId: tGroupId,
        habit: tHabit,
      )).thenAnswer((_) async => Failure(error: tError));

      // Act
      final result = await addHabitUseCase.exec(tParams);

      // Assert
      expect(result, isA<Failure>());
      expect((result as Failure).error, tError);
      verify(mockHabitRepo.createHabit(
        title: tHabitTitle,
        weight: tHabitWeight,
      )).called(1);
      verify(mockGroupRepo.addHabitToGroup(
        groupId: tGroupId,
        habit: tHabit,
      )).called(1);
      verifyNoMoreInteractions(mockHabitRepo);
      verifyNoMoreInteractions(mockGroupRepo);
    });
  });
}
