import 'dart:typed_data';

Future<Map<int, List<Uint8List>>> getListsToLookFor() async {
  // Fetch the dynamic values
  //int x = await fetchX();
  //int y = await fetchY();
  // ... fetch other values ...

  // Construct the map
  return {
    2: [
      Uint8List.fromList([59, 193, 15]),
    ],
    4: [
      //Turn on SSE not real values
      Uint8List.fromList([204, 210, 210]),
    ],
    5: [
      Uint8List.fromList([204, 216, 03]),
      //Values taken from PA$
      Uint8List.fromList([204, 193, 186]),
      Uint8List.fromList([204, 190, 216]),
      Uint8List.fromList([204, 55, 68]),
      Uint8List.fromList([204, 169, 155]),
      Uint8List.fromList([204, 189, 205]),
      Uint8List.fromList([204, 238, 14]),
      Uint8List.fromList([204, 189, 52]),
      Uint8List.fromList([204, 105, 186]),
      Uint8List.fromList([204, 240, 240]),
    ],
    7: [
      Uint8List.fromList([204, 213, 00]),
      Uint8List.fromList([204, 63, 25]),
      Uint8List.fromList([204, 153, 154]),
      Uint8List.fromList([204, 63, 25]),
      Uint8List.fromList([204, 153, 154]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 0, 100]),
      Uint8List.fromList([204, 240, 240]),
    ],
    8: [
      Uint8List.fromList([201, 32, 32]),
      Uint8List.fromList([201, 32, 32]),
      Uint8List.fromList([201, 240, 240]),
      Uint8List.fromList([203, 160, 0]),
      Uint8List.fromList([203, 240, 240]),
      Uint8List.fromList([203, 160, 255]),
      Uint8List.fromList([203, 240, 240]),
    ],
    9: [
      Uint8List.fromList([204, 213, 00]),
      Uint8List.fromList([204, 63, 25]),
      Uint8List.fromList([204, 153, 154]),
      Uint8List.fromList([204, 63, 25]),
      Uint8List.fromList([204, 153, 154]),
      Uint8List.fromList([204, 64, 64]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 0, 100]),
      Uint8List.fromList([204, 240, 240]),
    ],
    10: [
      Uint8List.fromList([204, 243, 00]),
      //not sure
      Uint8List.fromList([204, 63, 25]),
      Uint8List.fromList([204, 0, 4]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 1, 136]),
      Uint8List.fromList([204, 0, 4]),
      Uint8List.fromList([204, 240, 240]),
    ],
    12: [
      Uint8List.fromList([51, 59, 49]),
    ],
    13: [
      Uint8List.fromList([97, 99, 167]),
    ],
    14: [
      Uint8List.fromList([201, 0, 0]),
      Uint8List.fromList([201, 0, 0]),
      Uint8List.fromList([201, 240, 240]),
      Uint8List.fromList([203, 160, 0]),
      Uint8List.fromList([203, 240, 240]),
      Uint8List.fromList([203, 160, 255]),
      Uint8List.fromList([203, 240, 240]),
    ],
    16: [
      Uint8List.fromList([204, 233, 1]),
      Uint8List.fromList([204, 62, 76]),
      Uint8List.fromList([204, 204, 204]),
      Uint8List.fromList([204, 240, 240]),
    ],
    17: [
      Uint8List.fromList([204, 233, 2]),
      Uint8List.fromList([204, 62, 153]),
      Uint8List.fromList([204, 153, 154]),
      Uint8List.fromList([204, 240, 240]),
    ],
    18: [
      Uint8List.fromList([204, 213, 00]),
      Uint8List.fromList([204, 62, 153]),
      Uint8List.fromList([204, 153, 154]),
      Uint8List.fromList([204, 62, 153]),
      Uint8List.fromList([204, 153, 154]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 0, 100]),
      Uint8List.fromList([204, 240, 240]),
    ],
    19: [
      Uint8List.fromList([204, 217, 00]),
      Uint8List.fromList([204, 240, 240]),
    ],
    20: [
      Uint8List.fromList([67, 131, 31]),
    ],
    21: [
      Uint8List.fromList([204, 210, 4]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 210, 5]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 210, 6]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 0, 0]),
      Uint8List.fromList([204, 240, 240]),
    ],
    22: [
      Uint8List.fromList([67, 191, 16]),
    ],
  };
}
