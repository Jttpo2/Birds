import java.util.List;
static final boolean devMode = false;

static final int BIRD_LENGTH = devMode ? 100 : 5;
static final int BIRD_WIDTH = BIRD_LENGTH/2+1;
static final boolean FOLLOW_LEADER = false;
static float topSpeed = devMode ? 3: 10;
static float acceleratorMultiplier = topSpeed*0.04; // how fast bird changes course towards mouse pointer. Low (0.01) looks like bees. 0.04 kind of like starlings
static float avoidanceEagerness = -0.1; // high (1) is nice for lots of small birds. -0.1 seems natural.
static float flyingDistance = BIRD_LENGTH*3;

static final int textSize = 10;
//DecimalFormat df = new DecimalFormat("#.#");


private static final int BIRD_AMOUNT = 1000;
List<Bird> birds;

private boolean isRunning = true;

color white = color(255, 255, 255);
color black = color(0, 0, 0);
color grey  = color(150, 150, 150);

PImage image;

void setup() {
  size(925, 750, P3D);
  background(grey);
  //frameRate(1);
  frameRate(35);
  colorMode(HSB, 255, 255, 255);

  image = loadImage("london-skyline[marytaughtme.files.wordpress.com].jpg");
  textSize(textSize);
  //df.setRoundingMode(RoundingMode.CEILING);

  birds = new ArrayList<Bird>();
  Bird bird = new Bird(width/2 - 20, height/2 - 20, birds, true); // leader  
  birds.add(bird);
  //bird = new Bird(width/2 + 20, height/2 + 20, birds);
  //birds.add(bird);

  // First dash of birds
  //for (int i=0; i<10; i++) {
  //  bird = new Bird(random(width/3, width/2*3), random(height/3, height/2*3), birds);
  //    birds.add(bird);  
  //}

  if (!devMode) {
    for (int i=0; i < sqrt(BIRD_AMOUNT); i++) {
      for (int j=0; j < sqrt(BIRD_AMOUNT); j++) {
        float x = (width/2/sqrt(BIRD_AMOUNT))*i - width;
        float y = (height/2/sqrt(BIRD_AMOUNT))*j - height;
        bird = new Bird(x, y, birds);
        birds.add(bird);
      }
    }
  }
}

void draw() {
  if (isRunning) {
    background(white);
    image(image, -3, height-image.height);

    for (Bird b : birds) {
      b.update();
      b.display();
    }
  }
  surface.setTitle("Birds      " + int(frameRate) + " fps");
  fill(grey);
  text("Speed: " + topSpeed, 310, height-textSize);
  text("DirChange: " + roundOff(acceleratorMultiplier), 385, height-textSize);
  text("Avoidance: " + roundOff(avoidanceEagerness), 470, height-textSize);
  text("Distance: " + roundOff(flyingDistance), 560, height-textSize);
}

private double roundOff(double value) {
  return (double)Math.round(value * 100d) / 100d;
}

void mousePressed() {
  isRunning = !isRunning;
}

void keyPressed() {
  switch (keyCode) {
  case 'a':
  case 'A': 
    topSpeed += 0.5;
    break;
  case 'z':
  case 'Z': 
    topSpeed -= 0.5;
    break;
  case 's': 
  case 'S': 
    acceleratorMultiplier += 0.05;
    break;
  case 'x':
  case 'X': 
    acceleratorMultiplier -= 0.05;
    break;
  case 'd':
  case 'D': 
    avoidanceEagerness += 0.05;
    break;
  case 'c': 
  case 'C': 
    avoidanceEagerness -= 0.05;
    break;
  case 'f':
  case 'F': 
    flyingDistance += 5;
    break;
  case 'v': 
  case 'V': 
    flyingDistance -= 5;
    break;
  }
}