abstract class LabEvent {}

class FetchLabTests extends LabEvent {
  final int labTestId;

  FetchLabTests(this.labTestId);
}