import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

// void main() async {
//   // Initialize the model with the correct model name and API key
//   final model = GenerativeModel(
//     model: 'gemini-2.0-flash',
//     apiKey: 'AIzaSyDZ0bjBJd7MdRXi4L9kPFaBW1COC1kpnlE',
//     tools: [
//       Tool(
//         functionDeclarations: [
//           FunctionDeclaration(
//             'multiply',
//             'Multiply two numbers and return the product.',
//             Schema(
//               SchemaType.object,
//               properties: {
//                 'x': Schema(SchemaType.number),
//                 'y': Schema(SchemaType.number),
//               },
//             ),
//           ),
//         ],
//       ),
//     ],
//   );

//   // Start a chat session
//   final chat = model.startChat();

//   print('Gemini 2.0 Flash Agent is running. Type "exit" to quit.');
//   while (true) {
//     stdout.write('\x1B[94mYou\x1B[0m: ');
//     final input = stdin.readLineSync();
//     if (input == null || input.toLowerCase() == 'exit') break;

//     final response = await chat.sendMessage(Content.text(input));

//     final text = response.text?.trim();
//     if (text != null && text.isNotEmpty) {
//       print('\x1B[93mGemini\x1B[0m: $text');
//     }

//     for (final candidate in response.candidates) {
//       for (final part in candidate.content.parts) {
//         if (part is FunctionCall) {
//           if (part.name == 'multiply') {
//             final x = part.args['x'] as num;
//             final y = part.args['y'] as num;
//             final result = x * y;
//             final followup = await chat.sendMessage(
//               Content.functionResponse(part.name, {'result': result}),
//             );
//             if (followup.text != null) {
//               print('\x1B[93mGemini\x1B[0m: ${followup.text}');
//             }
//           }
//         }
//       }
//     }
//   }
// }

Future<void> main() async {
  final apiKey = Platform.environment['GEMINI_API_KEY'];
  if (apiKey == null) {
    stderr.writeln('Please set the GEMINI_API_KEY environment variable.');
    exit(1);
  }

  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: apiKey,
    tools: [
      Tool(
        functionDeclarations: [
          FunctionDeclaration(
            'read_file',
            'Read the contents of a file at a relative path.',
            Schema(
              SchemaType.object,
              properties: {'path': Schema(SchemaType.string)},
            ),
          ),
          FunctionDeclaration(
            'list_files',
            'List all files in a given directory.',
            Schema(
              SchemaType.object,
              properties: {'dir': Schema(SchemaType.string)},
            ),
          ),
          FunctionDeclaration(
            'edit_file',
            'Overwrite the contents of a file with new content.',
            Schema(
              SchemaType.object,
              properties: {
                'path': Schema(SchemaType.string),
                'replace': Schema(SchemaType.string),
              },
            ),
          ),
        ],
      ),
    ],
  );

  final chat = model.startChat();

  print('Gemini 2.0 Flash Agent is running. Type "exit" to quit.');
  while (true) {
    stdout.write('\x1B[94mYou\x1B[0m: ');
    final input = stdin.readLineSync();
    if (input == null || input.toLowerCase() == 'exit') break;

    final response = await chat.sendMessage(Content.text(input));

    final text = response.text?.trim();
    if (text != null && text.isNotEmpty) {
      print('\x1B[93mGemini\x1B[0m: $text');
    }

    for (final candidate in response.candidates) {
      for (final part in candidate.content.parts) {
        if (part is FunctionCall) {
          final result = await handleToolCall(part);
          print('\x1B[92mTool\x1B[0m: ${part.name}(${part.args})');
          final response = await chat.sendMessage(
            Content.functionResponse(part.name, {'result': result}),
          );
          print('\x1B[93mGemini\x1B[0m: ${response.text}');
        }
      }
    }
  }
}

Future<String> handleToolCall(FunctionCall call) async {
  final args = call.args;
  try {
    switch (call.name) {
      case 'read_file':
        return await readFile(args['path'] as String);
      case 'list_files':
        return await listFiles(args['dir'] as String);
      case 'edit_file':
        return await editFile(
          args['path'] as String,
          args['replace'] as String,
        );
      default:
        return 'Unknown tool: ${call.name}';
    }
  } catch (e) {
    return 'Error executing ${call.name}: $e';
  }
}

Future<String> readFile(String path) async {
  final file = File(path);
  if (!await file.exists()) return 'File not found: $path';
  return await file.readAsString();
}

Future<String> listFiles(String dirPath) async {
  final dir = Directory(dirPath);
  if (!await dir.exists()) return 'Directory not found: $dirPath';
  final entries = await dir.list().toList();
  return entries.map((e) => e.path).join('\n');
}

Future<String> editFile(String path, String content) async {
  final file = File(path);
  await file.writeAsString(content);
  return 'File $path updated successfully.';
}
