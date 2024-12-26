# notes_task_app

This is a Flutter-based notes management app integrated with Firebase. The app allows users to create, view, and delete notes. It supports user authentication with Firebase and implements a simple user interface across six screens. The app uses Riverpod for state management and follows the MVVM architecture for better scalability and code maintainability.

## Features

- **User Authentication**: Users can sign up, sign in, and access their personalized notes.
- **Notes Management**: Users can create, view, and delete notes. 
  - Note: A user can only delete their own notes. They can view all notes, including those created by other users, but cannot delete or modify others' notes.
- **Six Screens**:
  - **Sign Up**: Users can create a new account.
  - **Sign In**: Existing users can log in.
  - **Home**: Displays a list of notes created by all users.
  - **Note Detail**: View detailed information about a specific note.
  - **Create Note**: Allows users to create new notes.
  - **Profile**: Shows user profile information and allows users to sign-out their account.
- **State Management**: Riverpod is used for managing state.
- **Architecture**: MVVM (Model-View-ViewModel) architecture is followed for clean code organization and separation of concerns.