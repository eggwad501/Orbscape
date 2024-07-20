<div>

<span class="c15"></span>

</div>

# <span class="c13 c6">iOS Design Doc</span>

<span class="c13 c6"></span>

<span class="c6 c16">Group Members: </span><span class="c11">Nhat Tran,
Nicholas Ensey, Pranav Srinivasan, Ronghua Wang</span>

<span class="c16 c6">Application Name: </span><span
class="c11">Orbscape</span>

# <span class="c13 c6">General Description:</span>

<span class="c1">Our app is a game where the player controls a ball,
utilizing the phone’s gyro controls, to complete mazes. More
specifically, as the player tilts and rotates their phone, rotating the
maze, the ball moves along the maze as gravity pulls it down. There will
be different maze levels that the player can pick from, each varying in
difficulty. The goal of the game is to complete the maze as fast as
possible while collecting stars, our game’s currency, along the way. The
player will have completed the level upon reaching the exit, wherein the
player will be rewarded with additional star currencies based on their
completion time. </span>

<span class="c1">These collected stars can then be used to unlock
various customization options. This includes purchasing cosmetic effects
for the ball like skins, trails, and effects. It can also be used to
customize the mazes, such as the background gradient and the wall skin.
The background music and sound effects can also be purchased and
customized using the star currency. </span>

<span class="c1"></span>

# <span class="c6">Framework List:</span><span class="c13 c6"> </span>

####   <span class="c1">Required</span>

<!-- -->

-   <span class="c1">Core Data to store settings and player data that
    includes the player’s stars and customization options</span>

<!-- -->

####   <span class="c1">Chosen</span>

<!-- -->

-   <span class="c1">Core Motion to rotate the screen to move the
    ball</span>
-   <span class="c1">Core Graphics to render the 2D game</span>
-   <span class="c1">Core Audio to play sounds and music when playing
    the game</span>
-   <span class="c1">Animation for menu options</span>

# <span class="c13 c6">Operational Descriptions:</span>

-   <span class="c1">Play Button: moves the user to the level select
    screen</span>
-   <span class="c1">Level Select Screen Difficulties (Easy, Medium,
    Hard): each button moves the user to the respective mazes</span>
-   <span class="c1">Customize Button: moves the user to the
    customization screen where they can select buttons to change their
    ball’s skin, sound, and theme. Changing skin, sounds, or themes
    leads to a mini pop-up asking for user confirmation, as well as a
    demo. </span>
-   <span class="c1">Cosmetic Screen: has a table of options for the
    user to click to change their ball’s appearance, sound effects, and
    maze themes by purchasing new ones with the stars they have
    earned</span>
-   <span class="c1">Gyro Controls: moves the orientation of the maze
    based on the phone’s position to allow the ball to traverse the
    maze</span>
-   <span class="c1">Pause Button: Pauses game, includes current run
    stats and options to go to settings, restart, or go to the home
    screen</span>
-   <span class="c1">Settings Button: opens options for sound effects,
    music, and credits</span>

<span class="c13 c6"></span>

# <span class="c6 c13">Screens:</span>

###   <span class="c1">Splash Screen</span>

<span class="c1">Displays the company name and logo while the app begins
loading. This screen will fade away after a few seconds and take the
user to the main title screen. </span>

![image7](https://github.com/user-attachments/assets/5764392e-d404-466d-a23b-90e50d3a76fc)
<span class="c1">  
</span>

------------------------------------------------------------------------

###   <span class="c1">Title Screen</span>

<span class="c1">The first page the user sees after loading in. The user
has the option to click on: </span>

-   <span class="c1">Play: play the game, showing the different levels
    available </span>
-   <span class="c1">Customize: customize the ball and other
    cosmetics</span>
-   <span class="c1">Setting: adjust volume settings</span>

<span class="c1"></span>

![image5](https://github.com/user-attachments/assets/453f59f6-9b45-4067-9fab-72a72364ddd1)

------------------------------------------------------------------------

<span class="c1"></span>

<span class="c1"></span>

###   <span class="c1">Level Select Screen</span>

<span class="c1">The user chooses to play between 3 set difficulties,
which changes the maze’s layout based on their choice. Harder
difficulties will increase the complexity and length of the maze, but
will also reward a higher amount of stars upon completion.</span>

![image4](https://github.com/user-attachments/assets/d179f0d3-8c39-477b-a2c8-fc96daf0ebc5)

------------------------------------------------------------------------

<span class="c1"></span>

###   <span class="c1">Play Screen</span>

<span class="c1">The user plays the selected level and receives stars
based on the level of difficulty and the amount of time taken to
complete the maze. The different color backgrounds differentiate the
different available levels. There will also be bonus stars, stating the
number of stars collected in the maze along the way. There would be
three separate view controllers for play, level, and completion screens
respectively.</span>

![image6](https://github.com/user-attachments/assets/342416d6-e0bd-4a31-9aa3-3d9008a354e5)

![image1](https://github.com/user-attachments/assets/6efcec20-5e27-4cf5-bdcb-2017e9426838)
![image9](https://github.com/user-attachments/assets/f3b16338-fc86-42b7-8622-3c68565794a6)

<span class="c1"></span>

<span class="c1"></span>

<span class="c1"></span>

<span class="c1"></span>

------------------------------------------------------------------------

###   <span class="c1">Pause Screen </span>

<span class="c1">The pause button is available for the user to click on
during the gameplay. Clicking on this button will take the user to a pop
up that shows the amount of stars the player currently has overall, and
the current time that the player is playing in the maze. There is also
various buttons that they can click on such as: </span>

-   <span class="c1">Restart: It restarts the game and takes the player
    back to the screen with “tap to start” </span>
-   <span class="c1">Settings: it takes the player to the setting screen
    </span>
-   <span class="c1">Quit: takes the player back to the main title
    screen </span>

![image8](https://github.com/user-attachments/assets/ec444250-6af0-4301-978f-0a987cfde9a1)

<span class="c1"></span>

<span class="c1"></span>

<span class="c1"></span>

------------------------------------------------------------------------

<span class="c1"></span>

<span class="c1"></span>

###   <span class="c1">Settings Screen</span>

<span class="c1">This screen allows the user to change the sound volume,
music volume, as well as view the credits for the app. Sound and music
volumes are independent of one another and can be adjusted to the user’s
preferences.</span>

![image2](https://github.com/user-attachments/assets/11c5821b-cee4-4d14-a0cd-5d9ae942906f)

------------------------------------------------------------------------

<span class="c1"></span>

###   <span class="c1">Customization Screen</span>

<span class="c1">The user can customize the appearance of their ball,
the sound effects that play when the ball collides, and the theme of the
maze. Each option will have its shop screen, where the user can purchase
the desired cosmetics with their acquired stars. When perusing through
the sound effect shop, users preview the sounds by tapping the volume
button next to it. All purchasable options will have a confirmation
pop-up screen so that users don’t misclick and accidentally lose their
stars on an undesired choice.</span>

<span class="c1"></span>

<span class="c1">Currently, the customizable items have not been
designed, these are placeholders. </span>

![image10](https://github.com/user-attachments/assets/36042e59-e61c-4da6-9b7c-beb6a582fc1a)

------------------------------------------------------------------------

<span class="c1"></span>

# <span class="c16 c6">Flow Diagram</span><span class="c1"> </span>

-   <span class="c1">The Current layout design was implemented in Figma,
    which can be viewed in detail in the following link. </span>
-   <span class="c11 c17"><a
    href="https://www.google.com/url?q=https://www.figma.com/design/IM4lBrR99H0XduL9IWbpjD/IOS-Project?node-id%3D0-1%26t%3DvlSxxYaI81Yb5NDC-1&amp;sa=D&amp;source=editors&amp;ust=1721471227671138&amp;usg=AOvVaw1UX4T8Zx7-jxzjhlBGEWUd"
    class="c14">Figma File</a></span><span class="c1"> </span>
    
![image3](https://github.com/user-attachments/assets/63f76919-e15c-4335-a9f5-62385ae4a01a)
