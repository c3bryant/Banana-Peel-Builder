# Bananapeel Eyeball Builder

Bananapeel Eyeball Builder is an AI-powered image generator app, crafted alongside my children during the 2023-2024 holiday season. Leveraging the capabilities of OpenAI's DALL-E-3, the app brings to life images from user-provided prompts.

## Key Features
- **Image Generation:** Generate images by entering prompts; DALL-E-3 takes care of the rest.
- **Cross-Platform:** Works on mobile (Android & iOS) and desktop (macOS & Windows) platforms.
- **Save Functionality:** Users can save their favorite generated images directly to their device.

## Getting Started
Before you can run the app, make sure to follow these setup steps:

1. Ensure you have Flutter installed on your system. If you don't, refer to the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
2. Clone the repository to your local machine.
3. Navigate to the project directory and run `flutter pub get` to install dependencies.
4. You must have an `.env` file at the root of the project with the `OPENAI_API_KEY` variable set to your OpenAI API key like so:
```
OPENAI_API_KEY=your_openai_api_key_here
```
5. To start the app, run `flutter run` in your terminal.

## Directory Structure
The project is organized into three main directories: `controllers`, `screens`, and `widgets` for modular development and easy maintenance.

```
bananapeel_eyeball/
├─ controllers/
│  ├─ image_controller.dart
├─ screens/
│  ├─ home.dart
├─ widgets/
│  ├─ custom_input_decoration.dart
│  ├─ error_snack.dart
│  ├─ success_snack.dart
├─ main.dart
```

## Fun Facts
- The app's UI graphics, including the icons and buttons, were generated with the app.
- A 10-second countdown is displayed while waiting for the generated images. This countdown is arbitrary; most image generation requests are completed in 10 seconds.

## License
This project is licensed under the MIT License - see the LICENSE file for details.