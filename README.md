# Grocemate :tangerine:

*Technologies Used*
- SwiftUI (90%), UIKit (10%)
- OpenAI API, Vision Framework, Firebase Authentication, Google Cloud Functions, CoreData and CloudKit, SpriteKit
- MVVM Pattern

Introducing Grocemate: Your favorite smart recipe book!

The idea for Grocemate was born when I wanted to take a picture of a recipe and have my phone instantly create a grocery list for me based on that recipe. This app is currently a work in progress but here are some fun screens and demos:

# Features
- Maintain a digital library of your recipes
- Scan a recipe from a cookbook or import a picture and Grocemate will automatically format and import it for you!
- Only have the ingredients? Through the power of LLMs, Grocemate will fill in the recipe steps for you.
- Your data is stored on your phone and synced with iCloud.

# Demos
## Demo of Recipe Scanning Feature
This is the most complicated feature so far. It requires users to be authenticated and to be using the app to call a Google Cloud Function. First, the user can scan in a single or multi-page recipe. I then use the Vision framework to text-recognition and generate a string of all the text in the image(s). That text is then sent to the Google Cloud Function which calls the Completions API provided by OpenAI. Finally, a JSON formatted recipe object is sent back to the app and the recipe is displayed for the user to verify.

Youtube Link
[![Recipe Scanning Demo](https://img.youtube.com/vi/3dojy7zi-zk/0.jpg)](https://www.youtube.com/watch?v=3dojy7zi-zk "Recipe Scanning Demo")

## Fun Login Screen
Authentication is done through Google Firebase and Sign in with Apple. It's a SwiftUI screen with a SpriteKit scene with physics behind it. The gravity in the physics world is adjusted according to the tilt of your phone, as specified by the accelerometer.

![Login Screen Demo](https://github.com/achi113s/Grocemate/blob/main/ReadmeResources/login_screen_demo.gif)

## Edit and Create Recipe Screen
This screen is generic. You can pass in any view model that conforms to RecipeDetailViewModelling. This allowed me to write one screen to handle creation of recipes through scanning, editing recipes, and manual recipe creation.

![Edit Create Recipe Screen](https://github.com/achi113s/Grocemate/blob/main/ReadmeResources/edit_create_screen_demo.gif)

