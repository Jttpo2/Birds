import java.util.List;

List<Bird> birds;

color white = color(255, 255, 255);
color black = color(0, 0, 0);
color grey  = color(150, 150, 150);

void setup() {
  size(800, 600);
  background(grey);

  birds = new ArrayList<Bird>();
  Bird bird = new Bird(width/2, height/2, birds);  
  birds.add(bird);
  bird = new Bird(width, height, birds);
  // birds.add(bird);
}

void draw() {
  background(grey);
  
  for (Bird b: birds) {
  	b.update();
  	b.display();
  }
}