Application Name: Orbscape


Group Members: Nhat Tran, Nicholas Ensey, Pranav Srinivasan, Ronghua Wang

General Description:
Our app is a game where the player controls a ball, utilizing the phone’s gyroscope controls, to complete mazes. 

Game Mechanics: 
- Player tilts and rotates their phone, rotating the maze, the ball moves along the maze as gravity pulls it down.
- Three different maze levels that the player can pick from, each varying in difficulty. 
- The goal of the game is to complete the maze as fast as possible before the timer ends. 
- Player can collect stars, our game’s currency, along the way. 
- If the player completes the game, they will keep the collected stars, otherwise, they will lose them. 
- The player will have completed the level upon reaching the exit.

Levels: 
- Players are more likely to keep the stars on easier runs, but can only collect a limited amount of stars.
- Players are less likely to keep the stars on harder runs, but can earn so much more stars in one run.

Customization: 
- Collected stars can then be used to unlock various customization options.
- This includes purchasing cosmetic effects for the ball like skins and sound effects, and for the maze, such as the background gradient. 

Dependencies: 
- iOS above 17.5+
- Swift 5
- Xcode 15.4

Special Instructions: 
- iPhone models above 4+ (an iPhone with Gyroscope sensor)
- Must be played on a phyical iPhone and not a simulator
- Open Orbscape.xcodeproj from the main folder 
  

| Feature | Description | Contribution |
|----------|----------|----------|
| Design | Original design of app structure | 25% Pranav, 25% Nhat, 25% Ronghua, 25% Nick |
| Presentation/Documentation | Presentation about app and demo | 25% Pranav, 25% Nhat, 25% Ronghua, 25% Nick |
| Core Data | End to end core data. Saves selected and purchasable items and its statuses, settings, star counts, and optional functionality for resetting core data | 100% Pranav |
| Maze Generator | Maze generation for walls and stars, entrance and exit holes, and its optimization | 100% Nhat |
| Collision | Handling collision between ball, walls, and stars | 100% Nhat | 
| Sounds & Music | Integrated sound effects on collision with stars using SKAction. Integrated background music across all views using AVFAudio. | 100% Nick |
| Timer | Created countdown timer that updates the Gameplay UI and EndGameVC and also functions with pausing and resuming | 100% Nick |
| Gyro Controls | Utilized core motion to allow the player to control the gravity of the world based on accelerometer data | 100% Nick |
| UI/UX & VC integration | End to end UI/UX design including integrated all view controllers with correct animation | 100% Ronghua |
| Custom Items Table Selection | Developed dynamic table views and selection, reused for various customization options | 100% Ronghua |
| Purchasing Conditions | Check if purchasing can be made; update stars after purchasing, update UI image | 33% Nick, 33% Pranav, 33% Ronghua |


