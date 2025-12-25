import 'dart:ffi';

import 'package:ffi/ffi.dart';

// enum NT_Type
const ntTypeUnassigned = 0;
const ntTypeBoolean = 0x01;
const ntTypeDouble = 0x02;
const ntTypeString = 0x04;
const ntTypeRaw = 0x08;
const ntTypeBooleanArray = 0x10;
const ntTypeDoubleArray = 0x20;
const ntTypeStringArray = 0x40;
const ntTypeRPC = 0x80;
const ntTypeInteger = 0x100;
const ntTypeFloat = 0x200;
const ntTypeIntegerArray = 0x400;
const ntTypeFloatArray = 0x800;

// WPI_String type from <wpi/string.h>
final class WPIString extends Struct {
  external Pointer<Utf8> str;

  @Size()
  external int len;
}

Pointer<WPIString> toWpiString(String s) {
  final p = calloc.allocate<WPIString>(sizeOf<WPIString>());
  p.ref.len = s.length;
  p.ref.str = s.toNativeUtf8();

  return p;
}

String wpiToDartString(Pointer<WPIString> wpi) {
  return wpi.ref.str.toDartString(length: wpi.ref.len);
}

/* NT_Value stuff here */
final class NTValue extends Struct {
  @Int()
  external int type; // enum NT_Type
  @Int64()
  external int lastChange;
  @Int64()
  external int serverTime;

  external NTValueInner data;
}

final class NTBooleanArray extends Struct {
  external Pointer<Int> arr;
  @Size()
  external int size;
}

final class NTDoubleArray extends Struct {
  external Pointer<Double> arr;
  @Size()
  external int size;
}

final class NTFloatArray extends Struct {
  external Pointer<Float> arr;
  @Size()
  external int size;
}

final class NTInt64Array extends Struct {
  external Pointer<Int64> arr;
  @Size()
  external int size;
}

final class NTStringArray extends Struct {
  external Pointer<WPIString> arr;
  @Size()
  external int size;
}

final class NTRawData extends Struct {
  external Pointer<Uint8> data;
  @Size()
  external int size;
}

final class NTValueInner extends Union {
  @Int()
  external int vBoolean; // why they decided to reimplement booleans as ints, I have no clue.

  @Int64()
  external int vInt;

  @Float()
  external double vFloat;

  @Double()
  external double vDouble;

  external WPIString vString;

  external NTRawData vRaw;

  external NTBooleanArray arrBoolean;

  external NTDoubleArray arrDouble;

  external NTFloatArray arrFloat;

  external NTInt64Array arrInt;

  external NTStringArray arrString;
}

/* End of NT_Value stuff */
