
/* @pjs preload="london-skyline[marytaughtme.files.wordpress.com].jpg"; */ // Preloading file for web
/*
  -Must design to work with attractor following mouse before Particle inheritance refactor.

  Join flocks if in same area for enough time
  Fly away from chasing predator. Predator visible, larger, faster and eats birds, making them disappear.
  Reproduction algorithm spawning birds as they are eaten. 
  Birds mating in the air. Popularity rating. 
  Unfitness function, aging slows them down. Gets eaten. 
  Slow birds congregate into own flock.
  Stamina. Rest on structures when done. 
  Gamify somehow. Earn points. Fly as many birds through loops. Loops have to be passed on time. Birds disappear with time. Birds represent time. 
  Physics engine. Accelerating downwards and slowing going up.
  -Mass.
  Attractor and repeller.
  Wind. Gusts.
  Friction.
  -Air (fluid resistance).
*/

private boolean createAllAtonce = false;
private boolean isRunning = true;
private boolean followMouse = false;  

final int BIRD_AMOUNT = 200;
final int FLOCK_AMOUNT = 2;

static final int BIRD_LENGTH = 5;
static final int BIRD_WIDTH = BIRD_LENGTH/2+1;
static final boolean FOLLOW_LEADER = false;
static float topSpeed = 7;
static float acceleratorMultiplier = topSpeed*0.07; // how fast bird changes course towards mouse pointer. Low (0.01) looks like bees. 0.04 kind of like starlings
static float avoidanceEagerness = 0.8; // low (-1) is nice for lots of small birds. 0.1 seems natural.
static float flyingDistance = BIRD_LENGTH*3;

static final float G = 0.1;
PVector wind = new PVector(0.2, 0);
final Liquid AIR = new Liquid(0.005);
Attractor attractor;

static final int sizeOfText = 10;

ArrayList<Flock> flocks;

final color white = color(255, 255, 255);
final color black = color(0, 0, 0);
final color grey  = color(150, 150, 150);
final int[] hues = {210, 80, 30, 100, 120, 150, 250, 180, 200, 10, 50, 160, 230, 20, 40, 60, 70, 90, 110, 130, 140, 170, 190, 220, 240};

final long CREATION_INTERVAL = 1000*10;
long lastCreationTime = millis();

PImage bgImage;

Ejaculation murder;

void setup() {
  // fullScreen(P2D);
  size(925, 750, P2D);  
  //frameRate(1);
  frameRate(40);
  colorMode(HSB, 255, 255, 255);

  bgImage = loadImage("london-skyline[marytaughtme.files.wordpress.com].jpg");
  bgImage.resize(width+3,0);
  textSize(sizeOfText);

  // murder = new Ejaculation(new PVector(width/2, height/2), 100, true);

  flocks = new ArrayList<Flock>();
  if (createAllAtonce) {
    for (int i=0; i<FLOCK_AMOUNT; i++) {
      deployNewFlock();
    }  
  } else {
    deployNewFlock();
  }

   attractor = new Attractor(new PVector((int)(9*width/10), (int)(1*height/10)), 10000);
}

void draw() {
  if (isRunning) {
    background(white);
    image(bgImage, -3, height-bgImage.height);
    attractor.display();
    showNumbers();

    if (!createAllAtonce) {
      if (lastCreationTime + CREATION_INTERVAL < millis()) {
        deployNewFlock();
        lastCreationTime = millis();
      } 
    }

    for (Flock f: flocks) {
      // f.applyForce(wind);
      f.applyAttractor(attractor);
      f.run();
    }

    // murder.run();
  }
}

private float roundOff(float value) {
  return (float)Math.round(value * 100f) / 100f;
}

void mousePressed() {
  toggleMouseControl();
}

void keyPressed() {
  switch (key) {
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
    case ' ': deployNewFlock(); 
    break;
    case 'p':
    case 'P': isRunning = !isRunning;
    break;
  }

  if ('1' <= key && key <= '9') {
    int num = key - '0';
    num--;
    if (num < flocks.size()) {
      Flock flock = flocks.get(num);
      flock.toggleFollowMouse();
    }
  } else if (keyCode == BACKSPACE) {
    removeLastFlock();
  }
}

private void showNumbers() {
  fill(grey);
  int initDistance = (int)(width/2.65);
  text("Speed: " + topSpeed, initDistance, height-sizeOfText);
  text("DirChange: " + roundOff(acceleratorMultiplier), initDistance+75, height-sizeOfText);
  text("Avoidance: " + roundOff(avoidanceEagerness), initDistance+160, height-sizeOfText);
  text("Distance: " + roundOff(flyingDistance), initDistance+250, height-sizeOfText);
  text(int(frameRate) + " fps", width-50, height-sizeOfText); 
}

private void deployNewFlock() {
  PVector pos = new PVector(random(0, width), height);
  if (flocks.size() < FLOCK_AMOUNT && flocks.size() <= hues.length) {
    flocks.add(new Flock(pos, BIRD_AMOUNT/FLOCK_AMOUNT, hues[flocks.size()], followMouse));
    lastCreationTime = millis();
  }
}

private void removeLastFlock() {
  flocks.remove(flocks.size()-1);
}

private void toggleMouseControl() {
  for (Flock f: flocks) {
    f.setFollowMouse(!followMouse);
  }
  followMouse = !followMouse;
}
