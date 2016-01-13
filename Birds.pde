import java.util.List;

static final boolean devMode = false;

private static final int BIRD_AMOUNT = 1000;
List<Bird> birds;

private boolean isRunning = true;

color white = color(255, 255, 255);
color black = color(0, 0, 0);
color grey  = color(150, 150, 150);

PImage image;

void setup() {
  size(925, 750);
  background(grey);
  //frameRate(1);
  frameRate(55);
  colorMode(HSB, 255, 255, 255);

  image = loadImage("london-skyline[marytaughtme.files.wordpress.com].jpg");

  birds = new ArrayList<Bird>();
  Bird bird = new Bird(width/2 - 20, height/2 - 20, birds, true); // leader  
  birds.add(bird);
  bird = new Bird(width/2 + 20, height/2 + 20, birds);
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

    for (Bird b: birds) {
      b.update();
      b.display();
    }  
  }
}
void keyPressed() {
    println("Key pressed");
  }

void mousePressed() {
  isRunning = !isRunning;
}