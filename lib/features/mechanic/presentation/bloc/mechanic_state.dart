abstract class MechanicState {
  const MechanicState();
}

class MechanicInitial extends MechanicState {
  const MechanicInitial();
}

class MechanicLoading extends MechanicState {
  const MechanicLoading();
}

class MechanicSubmitSuccess extends MechanicState {
  const MechanicSubmitSuccess();
}

class MechanicStatusSuccess extends MechanicState {
  final String status;
  const MechanicStatusSuccess(this.status);
}

class MechanicFailure extends MechanicState {
  final String message;
  const MechanicFailure(this.message);
}
