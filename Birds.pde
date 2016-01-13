import java.util.List;
static final boolean devMode = false;
private boolean isRunning = true;
private boolean followMouse = false;

final int BIRD_AMOUNT = 600;
final int FLOCK_AMOUNT = 10;

static final int BIRD_LENGTH = devMode ? 100 : 8;
static final int BIRD_WIDTH = BIRD_LENGTH/2+1;
static final boolean FOLLOW_LEADER = false;
static float topSpeed = devMode ? 3: 7;
static float acceleratorMultiplier = topSpeed*0.07; // how fast bird changes course towards mouse pointer. Low (0.01) looks like bees. 0.04 kind of like starlings
static float avoidanceEagerness = 0.8; // low (-1) is nice for lots of small birds. 0.1 seems natural.
static float flyingDistance = BIRD_LENGTH*3;

static final int textSize = 10;

List<Flock> flocks;

final color white = color(255, 255, 255);
final color black = color(0, 0, 0);
final color grey  = color(150, 150, 150);
final int[] hues = {210, 80, 30, 100, 120, 150, 250, 180, 200, 10, 50, 160, 230, 20, 40, 60, 70, 90, 110, 130, 140, 170, 190, 220, 240};

PImage bgImage;

void setup() {
  // fullScreen(P2D);
  size(925, 750, P2D);  
  //frameRate(1);
  frameRate(40);
  colorMode(HSB, 255, 255, 255);

  bgImage = loadImage("london-skyline[marytaughtme.files.wordpress.com].jpg");
  bgImage.resize(width+3,0);
  textSize(textSize);

  flocks = new ArrayList<Flock>();
  for (int i=0; i<FLOCK_AMOUNT; i++) {
    // flocks.add(new Flock(BIRD_AMOUNT/FLOCK_AMOUNT, hues[i]));
    deployNewFlock();
  }
}

void draw() {
  if (isRunning) {
    background(white);
    image(bgImage, -3, height-bgImage.height);
    showNumbers();

    for (Flock f: flocks) {
      f.update();
      f.display();
    }
  }
}

private double roundOff(double value) {
  return (double)Math.round(value * 100d) / 100d;
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
    case ' ': isRunning = !isRunning;
    break;
  }

  if ('1' <= key && key <= '9') {
    int num = key - '0';
    Flock flock = flocks.get(num);
    flock.toggleFollowMouse();
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

private void deployNewFlock() {
  if (flocks.size() <= FLOCK_AMOUNT && flocks.size() <= hues.length) {
    flocks.add(new Flock(BIRD_AMOUNT/FLOCK_AMOUNT, hues[flocks.size()]));
  }
}

private void toggleMouseControl() {
  for (Flock f: flocks) {
    f.setFollowMouse(!followMouse);
  }
  followMouse = !followMouse;
}