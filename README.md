# dart_agent
An example AI agent written in Dart using the Gemini API inspired by the AI
agent written in Go by Thorsten Ball in his blog post [How to Build an Agent or:
The Emperor Has No Clothes](https://ampcode.com/how-to-build-an-agent).

## Usage
Start by [getting yourself a Gemini API key](https://aistudio.google.com/app/apikey) and making
sure that the `GEMINI_API_KEY` environment variable is set before running the app.

You can run it at the CLI like so:

```sh
$ dart bin/main.dart
```

## Example: horsing around
```
$ dart bin/main.dart

Gemini 2.0 Flash Agent is running. Type "exit" to quit.
You: Hey! My name is Chris! How are you?
Gemini: Hi Chris! I'm doing well, thank you for asking!

How can I help you today?
You: I recently purchased a horse and I'm looking for some playful horse-related names based on my own name. Can you give me a hand with that?
Gemini: That's a fun idea, Chris! Let's brainstorm some playful horse names related to your name:

1.  **Chris-Cross Gallop:** Playful, suggests movement and maybe jumping.
2.  **Krispy Kremeigh:** A silly pun combining a treat with a horse sound.
3.  **Sir Chris-top-hoof:** A more elaborate, knightly-sounding pun, especially if your full name is Christopher.
4.  **Chriscendo:** Like a musical crescendo, suggesting growing speed or presence.
5.  **Chrispy Trot:** Simple, catchy, and combines "Chris" with a horse gait.
6.  **Christo-fur:** If your horse is particularly furry or fluffy!
7.  **Captain Chris:** Simple, classic, gives a sense of leadership.
8.  **Whinny Chris:** Combines a horse sound with your name.
9.  **Topher Trot:** If your full name is Christopher, using the shorter form.
10. **Chrispy Comet:** Suggests speed and energy.

Hopefully, one of these sparks some inspiration! Do any of these sound like a good fit for your new horse's personality? Or would you like some more ideas?
You: exit
```

## Example: read_file tool
```
You: Gemini, buddy, help me solve a riddle in the secret-file.txt file.
Gemini: Okay, buddy! I can help with that. First, let's see what the riddle is.
Tool: read_file({path: secret-file.txt})
Gemini: Okay, the riddle in `secret-file.txt` is:

"what animal is the most disagreeable because it always says neigh?"

The answer is a **horse**!

Do you need help with anything else, buddy?
You: what's going on in bin/main.dart? be brief!
Tool: read_file({path: bin/main.dart})
Gemini: It's a Dart command-line application that:
1.  Connects to the Gemini API using an API key.
2.  Defines tools for file operations (`read_file`, `list_files`, `edit_file`).
3.  Enters a loop to chat with the user via the console.
4.  Sends user input to the Gemini model.
5.  Handles function calls requested by the model by executing corresponding local Dart functions for file system interaction.
6.  Sends the results back to the model and prints the final response.
```

## Example: list_files tool
```
You: what do you see in this directory?
Tool: list_files({})
Gemini: Okay, I see the following files and directories in the current directory:

*   `.DS_Store` (macOS metadata file)
*   `bin` (directory, likely containing executable scripts)
*   `CHANGELOG.md` (Markdown file)
*   `pubspec.lock` (Dart package lock file)
*   `secret-file.txt` (Text file)
*   `README.md` (Markdown file)
*   `pubspec.yaml` (Dart package configuration file)
*   `.gitignore` (Git configuration file)
*   `analysis_options.yaml` (Dart analysis configuration file)
*   `.dart_tool` (Dart build/cache directory)
*   `.git` (Git repository directory)
*   `.vscode` (VS Code editor configuration directory)

You: tell me about all of the Dart and Dart-project-related files in this directory and in the bin directory
Tool: list_files({})
Tool: list_files({dir: bin})
Gemini: Okay, I can list the files in the current directory and the `bin` directory and then describe the Dart-related ones.

Based on the file listing:

**In the `bin` directory:**

*   `bin/main.dart`: This is a Dart source code file, likely the main entry point for an executable application.

**In the current directory (`./`):**

*   `pubspec.yaml`: This is the core Dart project definition file. It defines the project's name, description, dependencies, and other metadata.
*   `pubspec.lock`: This file locks the specific versions of the dependencies listed in `pubspec.yaml` to ensure reproducible builds. It's automatically generated or updated when you run `dart pub get`.
*   `analysis_options.yaml`: This file configures the Dart static analyzer and linter rules for the project.
*   `.dart_tool/`: This directory is created and managed by the Dart/Flutter tools. It contains build artifacts, package configuration files (`package_config.json`), and other temporary files needed for the project. You usually don't edit files inside it directly.
*   `.gitignore`: While not strictly a Dart file, it often contains entries specific to Dart projects to prevent generated files (like `.dart_tool/`, `build/`, `.packages`, `pubspec.lock` - although `pubspec.lock` is often committed) from being checked into version control.
*   `bin/`: This directory itself, which we already examined, typically contains the executable Dart scripts for a project.

You: what dart sdk version are we using for this project?
Gemini: Okay, the Dart SDK version constraint for the project is defined in the `pubspec.yaml` file. I'll read that file to find the constraint.
Tool: read_file({path: pubspec.yaml})
Gemini: Based on the `pubspec.yaml` file, the Dart SDK version constraint for this project is:

environment:
  sdk: ^3.7.2

This means the project requires a Dart SDK version that is compatible with `3.7.2`. Specifically, it allows any version from `3.7.2` up to (but not including) `4.0.0`.
```

## Example: edit_file tool

```
$ dart bin/main.dart

Gemini 2.0 Flash Agent is running. Type "exit" to quit.
You: hey, gemini, create fizzbuzz.js that I can run with nodejs and that has fizzbuzz in it and executes it
Tool: edit_file({path: fizzbuzz.js, replace: function fizzBuzz(n) {
  for (let i = 1; i <= n; i++) {
    if (i % 3 === 0 && i % 5 === 0) {
      console.log("FizzBuzz");
    } else if (i % 3 === 0) {
      console.log("Fizz");
    } else if (i % 5 === 0) {
      console.log("Buzz");
    } else {
      console.log(i);
    }
  }
}

// Execute the function up to 100
fizzBuzz(100);
})
Gemini: OK. I've created the `fizzbuzz.js` file with the FizzBuzz logic. It will print FizzBuzz up to 100 when you run it using Node.js (e.g., `node fizzbuzz.js`).
You: exit

$ node fizzbuzz.js
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
16
17
Fizz
19
Buzz
Fizz
22
23
Fizz
Buzz
26
Fizz
28
29
FizzBuzz
31
32
Fizz
34
Buzz
Fizz
37
38
Fizz
Buzz
41
Fizz
43
44
FizzBuzz
46
47
Fizz
49
Buzz
Fizz
52
53
Fizz
Buzz
56
Fizz
58
59
FizzBuzz
61
62
Fizz
64
Buzz
Fizz
67
68
Fizz
Buzz
71
Fizz
73
74
FizzBuzz
76
77
Fizz
79
Buzz
Fizz
82
83
Fizz
Buzz
86
Fizz
88
89
FizzBuzz
91
92
Fizz
94
Buzz
Fizz
97
98
Fizz
Buzz

$ dart bin/main.dart

Gemini 2.0 Flash Agent is running. Type "exit" to quit.
You: please edit fizzbuzz.js so that it only prints until 15 
Gemini: Okay, I can help with that. First, I need to read the current content of `fizzbuzz.js` to see how it's written.
Tool: read_file({path: fizzbuzz.js})
Gemini: Okay, I see the content of `fizzbuzz.js`. It defines a function `fizzBuzz(n)` and then calls it with `fizzBuzz(100);`.

To make it print only until 15, I will change the last line from `fizzBuzz(100);` to `fizzBuzz(15);`.

Here's the code to edit the file:

You: go ahead
Tool: edit_file({path: fizzbuzz.js, replace: function fizzBuzz(n) {
  for (let i = 1; i <= n; i++) {
    if (i % 3 === 0 && i % 5 === 0) {
      console.log("FizzBuzz");
    } else if (i % 3 === 0) {
      console.log("Fizz");
    } else if (i % 5 === 0) {
      console.log("Buzz");
    } else {
      console.log(i);
    }
  }
}

// Execute the function up to 15
fizzBuzz(15);
})
Gemini: OK. I have edited the `fizzbuzz.js` file to change the function call from `fizzBuzz(100)` to `fizzBuzz(15)`. The script will now only print the FizzBuzz sequence up to 15 when executed.
You: exit

$ node fizzbuzz.js
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
```

## Congrats!
```
$ dart bin/main.dart

Gemini 2.0 Flash Agent is running. Type "exit" to quit.
You: Create a congrats.js script that rot13-decodes the following string 'Pbatenghyngvbaf ba ohvyqvat n pbqr-rqvgvat ntrag!' and prints it
Tool: edit_file({replace: function rot13(str) {
  return str.replace(/[a-zA-Z]/g, function(char) {
    const charCode = char.charCodeAt(0);
    // Check case: uppercase A-Z (65-90), lowercase a-z (97-122)
    const base = charCode < 97 ? 65 : 97;
    // Apply ROT13 shift
    return String.fromCharCode(base + (charCode - base + 13) % 26);
  });
}

const encodedString = 'Pbatenghyngvbaf ba ohvyqvat n pbqr-rqvgvat ntrag!';
const decodedString = rot13(encodedString);
console.log(decodedString);
, path: congrats.js})
You: exit

$ node congrats.js 
Congratulations on building a code-editing agent!
```