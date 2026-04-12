import 'package:dart_mappable/dart_mappable.dart';

part 'physical_key.mapper.dart';

@MappableEnum()
enum PhysicalKey {
  enter("Enter"),
  space("Space"),
  arrowRight("Arrow Right"),
  arrowLeft("Arrow Left"),
  mouseLeft("Mouse Left"),
  mouseRight("Mouse Right"),
  mouseMiddle("Mouse Middle"),
  mouseBack("Mouse Back"),
  mouseForward("Mouse Forward");

  final String readableName;

  const PhysicalKey(this.readableName);
}
