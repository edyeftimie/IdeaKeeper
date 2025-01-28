import 'dart:async';
import 'package:exam_project/src/mvrc/controller/globals.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:io';

class WebSocketController {
  final String url;
  final Duration pingInterval;
  final Duration reconnectInterval;
  WebSocketChannel? _channel;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  late Stream _stream;

  final Function onReconnect;

  WebSocketController({
    required this.url,
    this.pingInterval = const Duration(seconds: 10),
    this.reconnectInterval = const Duration(seconds: 5),
    required this.onReconnect,
  }) {
    _stream = _initializeStream();
  }

  Stream get stream => _stream;

  Stream _initializeStream() {
    // Initialize the stream
    return _channel?.stream ?? Stream.empty();
  }

  // Future<bool> _isNetworkAvailable() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   // Handle different connection types
  //   debugPrint ('connectivityResult: $connectivityResult');
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return false; // No internet connection
  //   } else {
  //     return true; // Internet connection available (either Wi-Fi or mobile)
  //   }
  // }

  void connect() async {
    // bool isNetworkAvailable = await _isNetworkAvailable();
    
    // if (!isNetworkAvailable) {
    //   print('No network connection');
    //   isOnline.value = false;
    //   return;  // Early exit if there's no network
    // }

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      final channel = WebSocketChannel.connect(Uri.parse(url));
      bool isReady = true;
      try {
        debugPrint ('WebSocketChannel.connect: await channel.ready');
        await channel.ready.timeout(Duration(seconds: 2));
        debugPrint ('WebSocketChannel.connect: await channel.ready done');
      } on TimeoutException catch (e) {
        debugPrint ('No response from server: $e');
        isReady = false;
      } on SocketException catch (e) {
        debugPrint ('No response from server: $e');
        isReady = false;
      } on WebSocketChannelException catch (e) {
        debugPrint ('No response from server: $e');
        isReady = false;
      } catch (e) {
        debugPrint ('No response from server: $e');
        isReady = false;
        debugPrint('Error: $e');
      }
      if (!isReady) {
        isOnline.value = false;
        _scheduleReconnect();
        return;
      } else {
        debugPrint ('Server is ready');
        isOnline.value = true;
      }

      _channel!.stream.listen(
        (message) {
          print('Received: $message');
          _reconnectTimer?.cancel();
          isOnline.value = true;
          onReconnect();
          _startPinging();
        },
        onDone: () {
          print('Connection closed');
          isOnline.value = false;
          _scheduleReconnect();
        },
        onError: (error) {
          print('Error: $error');
          isOnline.value = false;
          _scheduleReconnect();
        },
      );

      _startPinging();
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      isOnline.value = false;
      _scheduleReconnect();
    }
  }

  void _startPinging() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(pingInterval, (timer) {
      if (_channel != null) {
        _channel!.sink.add('ping');
        print('Ping sent');
      }
    });
  }

  void _scheduleReconnect() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(reconnectInterval, () {
      print('Attempting to reconnect...');
      connect();
    });
  }

  void send(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void close() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
  }
}
