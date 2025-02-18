# m2dfs_bauchot_pictionary

A new Flutter project for a Pictionary game.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)

## Introduction

m2dfs_bauchot_pictionary is a Flutter-based application that allows users to play a digital version of the classic Pictionary game. Users can log in, sign up, create or join games, and enjoy drawing and guessing with friends.

## Features

- User Authentication (Login and Sign Up)
- Create and Join Game Sessions
- Team Building
- Drawing and Guessing Game Mechanics
- QR Code for Game Joining
- Beautiful UI with Gradient Backgrounds

## Installation

To get started with the project, follow these steps:

1. **Clone the repository:**
    ```sh
    git clone https://github.com/yourusername/m2dfs_bauchot_pictionary.git
    cd m2dfs_bauchot_pictionary
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Run the application:**
    ```sh
    flutter run
    ```

## Usage

After installing the application, you can start using it by following these steps:

1. **Open the app** on your device or emulator.
2. **Sign Up** for a new account or **Log In** if you already have one.
3. **Create a new game** or **Join an existing game** using a QR code.
4. **Build your team** and start playing Pictionary!

## Documentation

### Pages

- **HomePage**: The main screen of the app where users can log in, sign up, or start a new game.
- **Login**: A widget that represents the login screen, allowing users to log in to their accounts.
- **SignUp**: A widget that represents the sign-up screen, allowing users to create a new account.
- **StartGame**: A widget that represents the start game screen, allowing users to create or join a game session.
- **TeamBuilding**: A widget that represents the team building screen, allowing users to form teams and prepare for the game.
- **ChallengeCreation**: A widget that allows users to create new challenges for the game.
- **ChallengeGuessing**: A widget that allows users to guess the challenge based on the drawing.
- **GameSummary**: A widget that shows the summary of the game, including the teams, scores, and challenges.

### Providers

- **teamProvider**: Manages the state of the teams, including the list of players in each team.
- **gameStatusProvider**: Manages the state of the game status, including fetching and updating the game status.
- **ChallengeProvider**: Manages the state of the challenges, including fetching and updating the list of challenges.

### Forms

- **LoginForm**: A form widget that handles user input for logging in, including fields for username and password.
- **SignupForm**: A form widget that handles user input for signing up, including fields for username, email, and password.
- **ChallengeForm**: A form widget that handles user input for creating a new challenge, including fields for the challenge name and description.

### Models

- **Player**: A model representing a player in the game, including properties like `id` and `name`.
- **Game**: A model representing a game session, including properties like `id`, `name`, and `players`.
- **Team**: A model representing a team in the game, including properties like `id`, `name`, and `players`.

### Services
- **playerService**: A service that handles player-related operations, including fetching and updating player data.