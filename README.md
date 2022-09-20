# Exercise-03a-Colors-and-Particles

Exercise for MSCH-C220

This exercise is the first opportunity for you to experiment with juicy features to our brick-breaker game. The exercise will provide you with several features that should move you towards the implementation of Project 03.

Fork this repository. When that process has completed, make sure that the top of the repository reads [your username]/Exercise-03a-Colors-and-Particles. Edit the LICENSE and replace BL-MSCH-C220-F22 with your full name. Commit your changes.

Press the green "Code" button and select "Open in GitHub Desktop". Allow the browser to open (or install) GitHub Desktop. Once GitHub Desktop has loaded, you should see a window labeled "Clone a Repository" asking you for a Local Path on your computer where the project should be copied. Choose a location; make sure the Local Path ends with "Exercise-03a-Colors-and-Particles" and then press the "Clone" button. GitHub Desktop will now download a copy of the repository to the location you indicated.

Open Godot. In the Project Manager, tap the "Import" button. Tap "Browse" and navigate to the repository folder. Select the project.godot file and tap "Open".

If you run the project, you will see a main menu followed by a simple brick-breaker game. We will now have an opportunity to start making it "juicier".

---

## Downloading Assets and collisions

Download the [Puzzle Pack from Kenney.nl](https://kenney.nl/assets/puzzle-pack). Unzip it, and then copy the following images from the png folder into `res://Assets/`:
 * ballBlue.png
 * ballGrey.png
 * paddleBlu.png
 * paddleRed.png

Open `res://Ball/Ball.tscn`. Delete the ColorRect node, and create two Sprite nodes as a child of Ball. Name the second Sprite node "Highlight". Set the Texture of the Sprite node to `res://Assets/ballGrey.png` and set the Texture of the Highlight node to `res://Assets/ballBlue.png`. Select the Highlight node, and in the Inspector->CanvasItem->Modulate, set the A value to 0.

After the ball hits an object, we want the blue ball to show up temporarily. We do that by setting `$Highlight.modulate.a = 1.0` and then slowly reducing it back to zero. The best place to decay the alpha value is probably in `_integrate_forces`:
```
	if $Highlight.modulate.a > 0:
		$Highlight.modulate.a -= decay
```

Now, open `res://Paddle/Paddle.tscn`. Repeat the same process as with the ball, except use `res://Assests/paddleRed.png` for the Sprite and `res://Assets/paddleBlu.png` for the Highlight. Because of how the paddle is situationed, both paddles will need to be positioned at (50,10).

After the paddle has been hit, we should also make the paddle's Highlight visible: `$Highlight.modulate.a = 1.0`. The alpha decay can be appended to `_physics_process`:
```
	if $Highlight.modulate.a > 0:
		$Highlight.modulate.a -= decay
```

If the ball hits the walls, we want them to flash red. This will be similar to our work with the sprites, except we will be manipulating the colors directly. In `res://Wall/Wall.gd`, if the wall is hit, set `$ColorRect.color = Color8(201,42,42)`. Then, in `_physics_process`, reduce the saturation and increase the value until it is white again:
```
 if $ColorRect.color.s > 0:
		$ColorRect.color.s -= decay
	if $ColorRect.color.v < 1:
		$ColorRect.color.v += decay
```

## Create a Theme

Download and unzip the following typefaces from The League of Movable Type:
 * [League Gothic](https://www.theleagueofmoveabletype.com/league-gothic)
 * [Orbitron](https://www.theleagueofmoveabletype.com/orbitron)

Once they have been downloaded and unzipped, copy `static/TTF/LeagueGothic-Regular.ttf` and `Orbitron Black.ttf` to `res://Assets`.

Now comes the monotonous process (sorry!) of setting up a UI theme. Open `res://UI/Main_Menu.tscn` and select the Main_Menu node. In the Inspector, select Theme->Theme = New Theme.

Using the eyedropper tool, select the label, and add a new DynamicFont. Edit that resource so that the theme uses `res://LeagueGothic-Regular.ttf` with a Size of 22.

Then, select the Button and create a new StyleBoxFlat for the normal button mode. Update the following properties:
 * BG Color = #1864ab
 * Border Width = (3,3,3,3)
 * Border->Color = #228be6
 * Corner Radius = (20,20,20,20)

Then, copy the StyleBoxFlat from the normal mode and paste it into the other modes: disabled, focus, hover, pressed. After pasting them, *make sure you select Make Uniquie for each one*.

Edit disabled:
 * BG Color = #868e96
 * Border->Color = #495057
 * Color->font_color_disabled = #495057

Edit focus:
 * Border->Color = #74c0fc

Edit hover:
 * Border->Color = #74c0fc

Edit pressed:
 * BG Color = #228be6

Save the theme as `res://UI/UI.tres`

For each of the UI scenes: `res://UI/End_Game.tscn`, `res://UI/Instructions.tscn`, `res://UI/Main_Menu.tscn`, `res://UI/Pause_Menu.tscn`, load `res://UI/UI.tres` as the theme for the root Control node. 

For the Label in `res://UI/Main_Menu.tscn`, override the font to use size=65. Save that font as `res://UI/Title.tres`. Load that for the title lables in `res://UI/End_Game.tscn`, `res://UI/Instructions.tscn`, `res://UI/Main_Menu.tscn`, and `res://UI/Pause_Menu.tscn`.

For `res://UI/HUD.tscn`, use `res://Assets/Orbitron Black.ttf` with size 16 for the Score and Time labels.

## Colors

Now, we want to procedurally color the bricks, depending on their score values. Look up the following [Open Color values](https://yeun.github.io/open-color/ingredients.html) and in `res://Brick/Brick.gd`, in the `_ready` callback, set the color based on the score value:
 * < 40: Grey 6
 * >= 40: Grape 6
 * >= 50: Violet 5
 * >= 60: Blue 6
 * >= 70: Lime 5
 * >= 80: Yellow 4
 * >= 90: Orange 5
 * >= 100: Red 8

The red and orange statements should look like this:
```
if score >= 100:
		$ColorRect.color = Color8(224,49,49)
	elif score >= 90:
		$ColorRect.color = Color8(253,126,20)
```
## Particles

Finally, open `res://Paddle/Paddle.tscn`, and, as a child of Paddle, add a CPUParticles2d node. Rename it "Confetti". Position it at (50,-10), and set these properties in the Inspector for that particle emitter:
 * Amount = 6
 * Time->Lifetime = 0.5
 * Time->One Shot = On
 * Time->Explosiveness = 0.7
 * Time->Randomness = 1
 * Drawing->Local Coords->Off
 * Drawing->Texture = `res://Assets/confetti.png`
 * Direction->Direction = (0,-1)
 * Direction->Spread = 25
 * Initial Velocity->Velocity = 250
 * Initial Velocity->Velocity Random = 0.6
 * Angular Velocity->Velocity = 800
 * Angular Velocity->Velocity Random = 1
 * Scale->Scale Amount Curve = New Curve
   * Set points for the curve at 1 and 0.3, so it smoothly decreases
 * Color->Color Ramp = New Gradient
   * Set the Gradient so it is opaque white (255,255,255,255) on the left side and completely transparent (255,255,255,0) on the right side
 * Hue Variation->Variation = 1
 * Hue Variation->Variation Random = 1

In `res://Paddle/Paddle.gd`, after the paddle has been hit, set `$Confetti.emitting = true`

We will, likewise, add a particle emitter to `res://Brick/Brick.tscn`. As a child of Brick, add a CPUParticles2d node. Rename it "Confetti". Position it at (45,15), and set these properties in the Inspector for that particle emitter:
 * Amount = 15
 * Time->Lifetime = 0.4
 * Time->One Shot = On
 * Time->Explosiveness = 0.5
 * Drawing->Texture = `res://Assets/bubble.png`
 * Emission Shape->Shape = Rectangle
 * Direction->Direction = (0,0)
 * Direction->Spread = 180
 * Gravity->Gravity = (0,0)
 * Initial Velocity->Velocity = 300
 * Initial Velocity->Velocity Random = 1
 * Scale->Scale Amount = 0.25
 * Scale->Scale Amount Random = 1
 * Scale->Scale Amount Curve = New Curve
   * Set points for the curve so it starts at 0.5, goes to 1 in the middle, and then 0 at the end. It should look like a little lopsided hill
 * Color->Color Ramp = New Gradient
   * Set the Gradient so it is opaque white (255,255,255,255) on the left side and completely transparent (255,255,255,0) on the right side
 * Hue Variation->Variation = 1
 * Hue Variation->Variation Random = 1

In `res://Brick/Brick.gd`, after the brick is set to die, set `$Confetti.emitting = true`. Then, update the statement in `_physics_process`, so the brick is deleted only `if dying and not $Confetti.emitting:`

---

Test the game and make sure it is working correctly. You should be able to see the colors, sprites, and added effects as you play.

Quit Godot. In GitHub desktop, you should now see the updated files listed in the left panel. In the bottom of that panel, type a Summary message (something like "Completes the exercise") and press the "Commit to master" button. On the right side of the top, black panel, you should see a button labeled "Push origin". Press that now.

If you return to and refresh your GitHub repository page, you should now see your updated files with the time when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (https://github.com/[username]/Exercise-03a-Colors-and-Particles) on Canvas.

The final state of the file should be as follows (replacing my information with yours):
```
# Exercise-03a-Colors-and-Particles

Exercise for MSCH-C220

The first steps in adding "juicy" features to a simple brick-breaker game.

## To play

Move the paddle using the mouse. Help the ball break all the bricks before you run out of time.


## Implementation

Built using Godot 3.5

## References
 * [Juice it or lose it — a talk by Martin Jonasson & Petri Purho](https://www.youtube.com/watch?v=Fy0aCDmgnxg)
 * [Puzzle Pack 2, provided by kenney.nl](https://kenney.nl/assets/puzzle-pack-2)
 * [Open Color open source color scheme](https://yeun.github.io/open-color/)
 * [League Gothic Typeface](https://www.theleagueofmoveabletype.com/league-gothic)
 * [Orbitron Typeface](https://www.theleagueofmoveabletype.com/orbitron)
 

## Future Development

Tweening, Screen Shake, Adding a face, Comet trail, Music and Sound, Shaders, etc.

## Created by 

Jason Francis
```
