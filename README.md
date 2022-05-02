# StackOverflowLite

Flutter project made to mimic stack overflow using flutter.
It contains a authentication module that allows the user to log in and register in the application, and a questions module that lists existing questions, adds answers and allows users to upvote answers.

### Running the project
To run the app in android you will need to install Android Studio and create a virtual device.
You will need a virtual device configured to run this application.

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

After that, you can run the app in your prefered emulator.

Just open your emulator and use 

```
flutter run
```

Or press f5 (If using vscode)

### Folder Structure

All the application code can be found inside the 'lib' folder.



The Modules folder contains subfolders for the views, separated by module (in this case, questions and auth).

```
lib/
|- App/
|- Core/
|- Modules/
    |- Auth/
    |- Question/
```

### Core

This folders contains the code that is not directly involved with a specific view.
In the Extensions and Helpers folders we have a couple classes that support the views in conversions and data modeling.
The services folder contains the api helper (for calling the firebase rest api) and the Response Model, that receives the firebase responses so that we can use them in the flutter app.

### Modules

This folder contains the actual modules of the application (the views).
In it we have a folder for the authentication module and another for the question module, with the respective pages inside them.