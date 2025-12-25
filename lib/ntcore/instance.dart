// this file is a LOT of boilerplate and comments
import 'dart:ffi';

import 'package:driver_dashboard/ntcore/ntcore_structs.dart';
import 'package:driver_dashboard/ntcore/values.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

/// A NetworkTables client. Uses the ntcore library from WPILib.
/// See the WPILib C++ docs on ntcore's C api (ntcore_c.h) for
/// more info.
class NTInstance {
  // Uses the right library name depending on platform and debug or release mode.
  final _libntcore = switch (defaultTargetPlatform) {
    // only linux and windows are supported.
    // need to use a different path since the file names are different for each platform.
    TargetPlatform.linux => DynamicLibrary.open(
      kDebugMode ? "libntcored.so" : "libntcore.so",
    ),
    TargetPlatform.windows => DynamicLibrary.open(
      kDebugMode ? "ntcored.dll" : "ntcore.dll",
    ),

    TargetPlatform.macOS => throw UnimplementedError(),
    TargetPlatform.android => throw UnimplementedError(),
    TargetPlatform.fuchsia => throw UnimplementedError(),
    TargetPlatform.iOS => throw UnimplementedError(),
  };

  // Slew of late final variables to set up the client and
  // lookup all of the C abi functions needed.

  // Creates an instance when the class is instantiated.
  late final _ntCreateInstance = _libntcore
      .lookupFunction<Pointer<Void> Function(), Pointer<Void> Function()>(
        "NT_CreateInstance",
      );
  late final Pointer<Void> _inst = _ntCreateInstance();
  late final Pointer<WPIString> _connectionName;

  // C functions used by the class. This is the entirety of the ABI bindings.
  // Names beginning with '_' are private to this library -
  // almost everything here is private to prevent directly interfacing with the ABI.
  /// void NT_StartClient4(NT_Inst inst, const struct WPI_String *identity)
  late final _ntStartClient4 = _libntcore
      .lookupFunction<
        Void Function(Pointer<Void>, Pointer<WPIString>),
        void Function(Pointer<Void>, Pointer<WPIString>)
      >("NT_StartClient4");

  /// void NT_SetServerTeam(NT_Inst inst, unsigned int team, unsigned int port)
  late final _ntSetServerTeam = _libntcore
      .lookupFunction<
        Void Function(Pointer<Void>, UnsignedInt, UnsignedInt),
        void Function(Pointer<Void>, int, int)
      >("NT_SetServerTeam");

  /// void NT_SetServer(NT_Inst isnt, const struct WPI_String *server_name, unsigned int port)
  late final _ntSetServer = _libntcore
      .lookupFunction<
        Void Function(Pointer<Void>, Pointer<WPIString>, UnsignedInt),
        void Function(Pointer<Void>, Pointer<WPIString>, int)
      >("NT_SetServer");

  /// NT_Entry NT_GetEntry(NT_Inst inst, const struct WPI_String *name)
  late final _ntGetEntry = _libntcore
      .lookupFunction<
        Pointer<Void> Function(Pointer<Void>, Pointer<WPIString>),
        Pointer<Void> Function(Pointer<Void>, Pointer<WPIString>)
      >("NT_GetEntry");

  /// void NT_GetEntryName(NT_Entry entry, struct WPI_String *name)
  late final _ntGetEntryName = _libntcore
      .lookupFunction<
        Void Function(Pointer<Void>, Pointer<WPIString>),
        void Function(Pointer<Void>, Pointer<WPIString>)
      >("NT_GetEntryName");

  /// void NT_DestroyInstance(NT_Inst inst)
  late final _ntDestroyInstance = _libntcore
      .lookupFunction<
        Void Function(Pointer<Void>),
        void Function(Pointer<Void>)
      >("NT_DestroyInstance");

  /// void NT_GetEntryValue(NT_Entry entry, struct NT_Value *value)
  late final _ntGetEntryValue = _libntcore
      .lookupFunction<
        Void Function(Pointer<Void>, Pointer<NTValue>),
        void Function(Pointer<Void>, Pointer<NTValue>)
      >("NT_GetEntryValue");

  /// NT_Bool NT_SetEntryValue(NT_Entry entry, const struct NT_Value *value)
  late final _ntSetEntryValue = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Pointer<NTValue>),
        int Function(Pointer<Void>, Pointer<NTValue>)
      >("NT_SetEntryValue");

  // idk if this will be useful or not I figured just in case
  /// int64_t NT_Now()
  late final _ntNow = _libntcore
      .lookupFunction<Int64 Function(), int Function()>("NT_Now");

  /// enum NT_Type NT_GetValueType(const struct NT_Value *value)
  late final _ntGetValueType = _libntcore
      .lookupFunction<
        Int Function(Pointer<NTValue>),
        int Function(Pointer<NTValue>)
      >("NT_GetValueType");

  /* Functions for getting inner data out of an NT_Value. I mean I'm pretty sure you could do this
     yourself but whatever fine. Note that the return values are whether or not the operation was successful.
     Unless it returns a pointer - then I assume that pointer may be null. */
  late final _ntGetValueBoolean = _libntcore
      .lookupFunction<
        Int Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Int>),
        int Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Int>)
      >("NT_GetValueBoolean");
  late final _ntGetValueInteger = _libntcore
      .lookupFunction<
        Int Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Int64>),
        int Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Int64>)
      >("NT_GetValueInteger");
  late final _ntGetValueFloat = _libntcore
      .lookupFunction<
        Int Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Float>),
        int Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Float>)
      >("NT_GetValueFloat");
  late final _ntGetValueDouble = _libntcore
      .lookupFunction<
        Int Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Double>),
        int Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Double>)
      >("NT_GetValueDouble");
  late final _ntGetValueString = _libntcore
      .lookupFunction<
        Pointer<Utf8> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        ),
        Pointer<Utf8> Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Size>)
      >("NT_GetValueString");
  late final _ntGetValueRaw = _libntcore
      .lookupFunction<
        Pointer<Uint8> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        ),
        Pointer<Uint8> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        )
      >("NT_GetValueRaw");
  late final _ntGetValueBooleanArray = _libntcore
      .lookupFunction<
        Pointer<Int> Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Size>),
        Pointer<Int> Function(Pointer<NTValue>, Pointer<Uint64>, Pointer<Size>)
      >("NT_GetValueBooleanArray");
  late final _ntGetValueIntegerArray = _libntcore
      .lookupFunction<
        Pointer<Int64> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        ),
        Pointer<Int64> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        )
      >("NT_GetValueIntegerArray");
  late final _ntGetValueFloatArray = _libntcore
      .lookupFunction<
        Pointer<Float> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        ),
        Pointer<Float> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        )
      >("NT_GetValueFloatArray");
  late final _ntGetValueDoubleArray = _libntcore
      .lookupFunction<
        Pointer<Double> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        ),
        Pointer<Double> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        )
      >("NT_GetValueDoubleArray");
  late final _ntGetValueStringArray = _libntcore
      .lookupFunction<
        Pointer<WPIString> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        ),
        Pointer<WPIString> Function(
          Pointer<NTValue>,
          Pointer<Uint64>,
          Pointer<Size>,
        )
      >("NT_GetValueStringArray");
  /* End of value getting functions */

  /* Value setting functions to push values to NT (these ones are actually in ntcore_c_types.h)
     Passing 0 as the current time will just use current NT time. All of these are basically just
     the entry handle, timestamp, and then the actual data to publish. */
  late final _ntSetBoolean = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Int),
        int Function(Pointer<Void>, int, int)
      >("NT_SetBoolean");
  late final _ntSetInteger = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Int64),
        int Function(Pointer<Void>, int, int)
      >("NT_SetInteger");
  late final _ntSetFloat = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Float),
        int Function(Pointer<Void>, int, double)
      >("NT_SetFloat");
  late final _ntSetDouble = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Double),
        int Function(Pointer<Void>, int, double)
      >("NT_SetDouble");
  late final _ntSetString = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Pointer<WPIString>),
        int Function(Pointer<Void>, int, Pointer<WPIString>)
      >("NT_SetString");
  late final _ntSetRaw = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Pointer<Utf8>, Size),
        int Function(Pointer<Void>, int, Pointer<Utf8>, int)
      >("NT_SetRaw");
  late final _ntSetBooleanArray = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Pointer<Int>, Size),
        int Function(Pointer<Void>, int, Pointer<Int>, int)
      >("NT_SetBooleanArray");
  late final _ntSetIntegerArray = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Pointer<Int64>, Size),
        int Function(Pointer<Void>, int, Pointer<Int64>, int)
      >("NT_SetIntegerArray");
  late final _ntSetFloatArray = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Pointer<Float>, Size),
        int Function(Pointer<Void>, int, Pointer<Float>, int)
      >("NT_SetFloatArray");
  late final _ntSetDoubleArray = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Pointer<Double>, Size),
        int Function(Pointer<Void>, int, Pointer<Double>, int)
      >("NT_SetDoubleArray");
  late final _ntSetStringArray = _libntcore
      .lookupFunction<
        Int Function(Pointer<Void>, Int64, Pointer<WPIString>, Size),
        int Function(Pointer<Void>, int, Pointer<WPIString>, int)
      >("NT_SetStringArray");
  /* End of value setting functions */

  // Could maybe add the getters as well in the future, although usually it
  // makes more sense to use the NT_Value struct.

  /* Cleanup functions - call these when you are done using structs! */
  late final _ntDisposeValue = _libntcore
      .lookupFunction<
        Void Function(Pointer<NTValue>),
        void Function(Pointer<NTValue>)
      >("NT_DisposeValue");

  /// This is here to deal with the wacky typing enforced on finalizers (see Pointer.asTypedList)
  late final _ntDisposeValueFinalizer = _libntcore
      .lookupFunction<
        Void Function(Pointer<Void>),
        void Function(Pointer<Void>)
      >("NT_DisposeValue");
  late final _ntFreeCharArray = _libntcore
      .lookupFunction<
        Void Function(Pointer<Utf8>),
        void Function(Pointer<Utf8>)
      >("NT_FreeCharArray");
  late final _ntFreeBooleanArray = _libntcore
      .lookupFunction<Void Function(Pointer<Int>), void Function(Pointer<Int>)>(
        "NT_FreeBooleanArray",
      );
  late final _ntFreeIntegerArray = _libntcore
      .lookupFunction<
        Void Function(Pointer<Int64>),
        void Function(Pointer<Int64>)
      >("NT_FreeIntegerArray");
  late final _ntReleaseEntry = _libntcore
      .lookupFunction<
        Void Function(Pointer<Void>),
        void Function(Pointer<Void>)
      >("NT_ReleaseHandle");

  // I literally went and checked the source code and all NT_InitValue does is
  // void NT_InitValue(NT_Value* value) {
  //   value->type = NT_UNASSIGNED;
  //   value->last_change = 0;
  //   value->server_time = 0;
  // }
  // So I won't even bother using it.

  /* End of C Functions */

  /// Creates a new instance connected to the specific team number and port.
  /// This can be changed later
  NTInstance({
    int teamNumber = 8726,
    int port = 5810,
    name = "8726DriverDashboard",
  }) {
    _connectionName = toWpiString(name);
    _ntStartClient4(_inst, _connectionName);
    _ntSetServerTeam(_inst, teamNumber, port);
  }

  // this method is messy but mostly copied + pasted a lot.
  /// Converts an NTValue struct into a NetworkTablesValue object.
  /// This will handle the memory for you so you DO NOT need to call NT_DisposeValue
  /// after this.
  NetworkTablesValue _cValueToDart(Pointer<NTValue> value) {
    // note: Pointer<Utf8>.toDartString() does NOT rely on existing memory
    // but the arrays do, which is why the finalizer is used for them.
    switch (_ntGetValueType(value)) {
      case ntTypeBoolean:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var val = calloc.allocate<Int>(sizeOf<Int>());
        var out = _ntGetValueBoolean(value, lastChange, val) == 1
            ? NTBooleanValue(
                lastChange.value,
                value.ref.serverTime,
                val.value == 1,
              )
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(val);
        _ntDisposeValue(value);
        return out;
      case ntTypeDouble:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var val = calloc.allocate<Double>(sizeOf<Double>());
        var out = _ntGetValueDouble(value, lastChange, val) == 1
            ? NTDoubleValue(lastChange.value, value.ref.serverTime, val.value)
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(val);
        _ntDisposeValue(value);
        return out;
      case ntTypeFloat:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var val = calloc.allocate<Float>(sizeOf<Float>());
        var out = _ntGetValueFloat(value, lastChange, val) == 1
            ? NTDoubleValue(lastChange.value, value.ref.serverTime, val.value)
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(val);
        _ntDisposeValue(value);
        return out;
      case ntTypeInteger:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var val = calloc.allocate<Int64>(sizeOf<Int64>());
        var out = _ntGetValueInteger(value, lastChange, val) == 1
            ? NTIntegerValue(lastChange.value, value.ref.serverTime, val.value)
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(val);
        _ntDisposeValue(value);
        return out;
      case ntTypeString:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var size = calloc.allocate<Size>(sizeOf<Size>());
        var ptr = _ntGetValueString(value, lastChange, size);
        var out = ptr.address != 0
            ? NTStringValue(
                lastChange.value,
                value.ref.serverTime,
                ptr.toDartString(length: size.value),
              )
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(size);
        _ntDisposeValue(value);
        return out;
      case ntTypeRaw:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var size = calloc.allocate<Size>(sizeOf<Size>());
        var ptr = _ntGetValueRaw(value, lastChange, size);
        var out = ptr.address != 0
            ? NTRawValue(
                lastChange.value,
                value.ref.serverTime,
                ptr.asTypedList(
                  size.value,
                  finalizer: Pointer.fromFunction(_ntDisposeValueFinalizer),
                  token: value.cast(),
                ),
              )
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(size);
        return out;
      case ntTypeBooleanArray:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var size = calloc.allocate<Size>(sizeOf<Size>());
        var ptr = _ntGetValueBooleanArray(value, lastChange, size);
        var boolList = <bool>[];
        NetworkTablesValue out;
        if (ptr.address != 0) {
          // for some reason this isn't implemented on Pointer<Int> so i'm going to do something slightly cursed.
          // oh well no one uses bool arrays anyway
          for (int i in ptr.cast<Int32>().asTypedList(
            size.value,
            finalizer: Pointer.fromFunction(_ntDisposeValueFinalizer),
            token: value.cast(),
          )) {
            boolList.add(i == 1);
          }
          out = NTBooleanArrayValue(
            lastChange.value,
            value.ref.serverTime,
            boolList,
          );
        } else {
          out = NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        }
        calloc.free(lastChange);
        calloc.free(size);
        return out;
      case ntTypeIntegerArray:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var size = calloc.allocate<Size>(sizeOf<Size>());
        var ptr = _ntGetValueIntegerArray(value, lastChange, size);
        var out = ptr.address != 0
            ? NTIntegerArrayValue(
                lastChange.value,
                value.ref.serverTime,
                ptr.asTypedList(
                  size.value,
                  finalizer: Pointer.fromFunction(_ntDisposeValueFinalizer),
                  token: value.cast(),
                ),
              )
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(size);
        return out;
      case ntTypeFloatArray:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var size = calloc.allocate<Size>(sizeOf<Size>());
        var ptr = _ntGetValueFloatArray(value, lastChange, size);
        var out = ptr.address != 0
            ? NTDoubleArrayValue(
                lastChange.value,
                value.ref.serverTime,
                ptr.asTypedList(
                  size.value,
                  finalizer: Pointer.fromFunction(_ntDisposeValueFinalizer),
                  token: value.cast(),
                ),
              )
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(size);
        return out;
      case ntTypeDoubleArray:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var size = calloc.allocate<Size>(sizeOf<Size>());
        var ptr = _ntGetValueDoubleArray(value, lastChange, size);
        var out = ptr.address != 0
            ? NTDoubleArrayValue(
                lastChange.value,
                value.ref.serverTime,
                ptr.asTypedList(
                  size.value,
                  finalizer: Pointer.fromFunction(_ntDisposeValueFinalizer),
                  token: value.cast(),
                ),
              )
            : NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        calloc.free(lastChange);
        calloc.free(size);
        return out;
      case ntTypeStringArray:
        var lastChange = calloc.allocate<Uint64>(sizeOf<Uint64>());
        var size = calloc.allocate<Size>(sizeOf<Size>());
        var ptr = _ntGetValueStringArray(value, lastChange, size);
        NetworkTablesValue out;
        if (ptr.address != 0) {
          List<String> arr = [];
          for (int i = 0; i < size.value; i++) {
            // dart WHY would you make the + operator work like that
            arr.add(wpiToDartString(ptr + i));
          }
          out = NTStringArrayValue(lastChange.value, value.ref.serverTime, arr);
        } else {
          out = NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
        }
        calloc.free(lastChange);
        calloc.free(size);
        _ntDisposeValue(value);
        return out;

      // Will return an unassigned value if it's either an unassigned value or broken.
      default:
        return NTUnassignedValue(value.ref.lastChange, value.ref.serverTime);
    }
  }

  /// Frees resources in use by this instance. Failing to call this before
  /// the object is destroyed will cause a slight memory leak. (If you never destroy this
  /// object you won't need to call this.)
  void dispose() {
    calloc.free(_connectionName);
    _ntDestroyInstance(_inst);
  }

  /// Sets the team number and port used to connect to the rio, without
  /// restarting the client. This is already done when the object is first constructed
  /// so only call this if the connection settings need to be changed.
  void updateConnectionSettings(int team, int port) {
    if (port > 0) {
      _ntSetServerTeam(_inst, team, port);
    }
  }

  /// Sets the server name and port used to connect to the NetworkTables server.
  /// It is generally recommended to use updateConnectionSettings for normal
  /// operation but if you pass localhost and 5810 to this you can connect to
  /// the sim GUI. Otherwise this works the same as updateConnectionSettings
  void updateServerNamePort(String serverName, int port) {
    if (port > 0) {
      _ntSetServer(_inst, toWpiString(serverName), port);
    }
  }

  /// Fetches the value of an entry.
  NetworkTablesValue getEntryValue(String entryName) {
    var entryHandle = _ntGetEntry(_inst, toWpiString(entryName));
    var value = calloc.allocate<NTValue>(sizeOf<NTValue>());
    _ntGetEntryValue(entryHandle, value);
    _ntReleaseEntry(entryHandle);
    return _cValueToDart(value);
  }

  // TODO: write all the other ones
  /// Sets a boolean value in NetworkTables
  void setEntryBool(String entryName, bool val) {
    var entryHandle = _ntGetEntry(_inst, toWpiString(entryName));
    _ntSetBoolean(entryHandle, 0, val ? 1 : 0);
    _ntReleaseEntry(entryHandle);
  }
}
