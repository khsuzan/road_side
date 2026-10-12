abstract class GarageState {
  const GarageState();
}

class GarageInitial extends GarageState {
  const GarageInitial();
}

class GarageLoading extends GarageState {
  const GarageLoading();
}

class GarageSuccess extends GarageState {
  const GarageSuccess();
}

class GarageFailure extends GarageState {
  final String message;
  const GarageFailure(this.message);
}
