<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# logger_interceptor

A simple Dart package providing an HTTP logging interceptor for debugging and monitoring network requests and responses. Useful for developers who want to log HTTP traffic in their Dart or Flutter applications.

## Features

- Logs HTTP requests and responses.
- Configurable log levels (request, response, error).
- Easy integration with `http` package or custom clients.
- Supports pretty-printing of JSON bodies.

## Getting started

Add `logger_interceptor` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  logger_interceptor: ^0.0.5