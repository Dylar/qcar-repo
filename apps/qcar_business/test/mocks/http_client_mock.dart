import 'dart:io';

import 'package:mockito/mockito.dart';

import '../ui/screens/app/app_test.mocks.dart';

// TODO do this in shared

class MockHttpOverrides extends HttpOverrides {
  MockHttpOverrides();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _createMockImageHttpClient();
  }
}

// Returns a mock HTTP client that responds with an image to all requests.
MockHttpClient _createMockImageHttpClient() {
  final MockHttpClient client = MockHttpClient();
  final MockHttpClientRequest request = MockHttpClientRequest();
  final MockHttpClientResponse response = MockHttpClientResponse();
  final MockHttpHeaders headers = MockHttpHeaders();

  when(client.getUrl(any)).thenAnswer((_) async => request);
  when(request.headers).thenReturn(headers);
  when(request.close()).thenAnswer((_) async => response);
  when(response.contentLength).thenReturn(_transparentImage.length);
  when(response.compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(response.statusCode).thenReturn(HttpStatus.ok);
  when(response.listen(
    any,
    onDone: anyNamed("onDone"),
    onError: anyNamed("onError"),
    cancelOnError: anyNamed("cancelOnError"),
  )).thenAnswer((Invocation inv) {
    final void Function(List<int>) onData = inv.positionalArguments[0];
    final void Function() onDone = inv.namedArguments[#onDone];
    final void Function(Object, [StackTrace]) onError =
        inv.namedArguments[#onError];
    final bool cancelOnError = inv.namedArguments[#cancelOnError];

    return Stream<List<int>>.fromIterable(<List<int>>[_transparentImage])
        .listen(onData,
            onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  });

  return client;
}

const List<int> _transparentImage = const <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];
