import java.util.List;
static final boolean devMode = false;

static final int BIRD_LENGTH = devMode ? 100 : 8;
static final int BIRD_WIDTH = BIRD_LENGTH/2+1;
static final boolean FOLLOW_LEADER = false;
static float topSpeed = devMode ? 3: 10.5;
static float acceleratorMultiplier = topSpeed*0.07; // how fast bird changes course towards mouse pointer. Low (0.01) looks like bees. 0.04 kind of like starlings
static float avoidanceEagerness = 0.8; // low (-1) is nice for lots of small birds. 0.1 seems natural.
static float flyingDistance = BIRD_LENGTH*3;

static final int textSize = 10;

private static final int BIRD_AMOUNT = 650;
List<Bird> birds;

private boolean isRunning = true;

color white = color(255, 255, 255);
color black = color(0, 0, 0);
color grey  = color(150, 150, 150);

PImage image;

void setup() {
  //size(925, 750, P3D);
  fullScreen(P2D);
  //frameRate(1);
  frameRate(40);
  colorMode(HSB, 255, 255, 255);

  image = loadImage("london-skyline[marytaughtme.files.wordpress.com].jpg");
  image.resize(width+3,0);
  textSize(textSize);

  birds = new ArrayList<Bird>();
  Bird bird = new Bird(width/2 - 20, height/2 - 20, birds, true); // leader  
  birds.add(bird);
  //bird = new Bird(width/2 + 20, height/2 + 20, birds);
  //birds.add(bird);

  // First dash of birds
  for (int i=0; i<10; i++) {
   bird = new Bird(random(width/3, width/2*3), random(height/3, height/2*3), birds);
     birds.add(bird);  
  }

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
    showNumbers();

    for (Bird b : birds) {
      b.update();
      b.display();
    }
  }
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

private void showNumbers() {
  fill(grey);
  int initDistance = (int)(width/2.65);
  text("Speed: " + topSpeed, initDistance, height-textSize);
  text("DirChange: " + roundOff(acceleratorMultiplier), initDistance+75, height-textSize);
  text("Avoidance: " + roundOff(avoidanceEagerness), initDistance+160, height-textSize);
  text("Distance: " + roundOff(flyingDistance), initDistance+250, height-textSize);
  text(int(frameRate) + " fps", width-50, height-textSize); 
}