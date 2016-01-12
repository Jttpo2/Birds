import java.util.List;

List<Bird> birds;
private static final int BIRD_AMOUNT = 10;

color white = color(255, 255, 255);
color black = color(0, 0, 0);
color grey  = color(150, 150, 150);

void setup() {
  size(800, 600);
  background(grey);
  frameRate(30);

  birds = new ArrayList<Bird>();
  Bird bird = new Bird(width/2 - 20, height/2 - 20, birds);  
  birds.add(bird);
  bird = new Bird(width/2 + 20, height/2 + 20, birds);
  //birds.add(bird);
  
  //for (int i=0; i < BIRD_AMOUNT; i++) {
  // bird = new Bird(width/BIRD_AMOUNT*i, height/BIRD_AMOUNT*i, birds);
  // birds.add(bird);
  //}

}

void draw() {
  background(grey);
  
  for (Bird b: birds) {
  	b.update();
  	b.display();
  }
}

void keyPressed() {
    println("Key pressed");
  }