
abstract class RefreshSchedulerRepo {
    void reschedule();
    Stream<void> get refreshStream;
}
