class Bird {
  private static final int BIRD_LENGTH = 2;
  private static final int BIRD_WIDTH = BIRD_LENGTH/2;

  private static final float MAX_COURSE_CHANGE = PI/60;
  private static final float FLYING_DISTANCE = BIRD_LENGTH*1.7;

  float topSpeed = 4;

  PVector pos;
  PVector vel;
  PVector acc;

  Triangle triangle;

  List<Bird> otherBirds;
 
  public Bird(float x, float y, List<Bird> otherBirds) {
    pos = new PVector(x, y);
    vel = PVector.fromAngle(3*PI/2);
    vel.mult(1);

    triangle = new Triangle((int) pos.x, (int) pos.y, BIRD_WIDTH, BIRD_LENGTH, vel.heading());
    this.otherBirds = otherBirds;
  }

  public void update() {  
    PVector mousePos = new PVector(mouseX, mouseY);
    aimFor(mousePos);
      
    avoidCollision();
    
    updatePos();
    repositionIfOutside();
    triangle.moveTo((int) pos.x, (int) pos.y);
    triangle.setAngle(vel.heading());
  }

  // Change course as much as possible towards desired direction
  private void aimFor(PVector targetPos) {
    PVector toTarget = PVector.sub(targetPos, pos);    
    toTarget.normalize();
    toTarget.mult(0.3);
    acc = toTarget;
    vel.add(acc);
    
    vel.limit(topSpeed);

  }

  // Update position from course and velocity
  private void updatePos() {
    pos.add(vel);
  }

  private void repositionIfOutside() {
    if (pos.x > width) {
      pos.x = 0;
    } else if (pos.x < 0) {
      pos.x = width;
    }
    if (pos.y > height) {
      pos.y = 0;
    } else if (pos.y < 0) {
      pos.y = height;
    }
  }

  public void display() {
    triangle.display();
  }

  private float getDirectionTo(Bird that) {
    PVector between = PVector.sub(that.pos, this.pos);
    float angleToBird = between.heading();
    return angleToBird;
  }

  private PVector getVectorTo(Bird that) {
    return PVector.sub(that.pos, this.pos);
  }

  private float getDistanceTo(Bird that) {
    PVector between = PVector.sub(that.pos, this.pos);
    return between.mag();
  }

  private Bird findClosest() {
    float distanceToClosest = Float.MAX_VALUE;
    Bird closest = null;
    for (Bird that: otherBirds) {
      if (this != that) { // No point in comparing with oneself
        float distance = getDistanceTo(that);
        if (distance < distanceToClosest) {
          distanceToClosest = distance;
          closest = that;
        }  
      }
    }
    return closest;
  }

  private void avoidCollision() {
    Bird closest = findClosest();
    if (closest == null) {
      return;
    }
    if (getDistanceTo(closest) <= FLYING_DISTANCE) {
      avoid(closest);  
      // println("Avoiding");
    }
  }

  private void avoid(Bird that) {
    if (isHeadingFor(that)) {    
      PVector toBird = PVector.sub(that.pos, this.pos);
      toBird.normalize();
      toBird.mult(-1);
      vel.add(toBird);
    }
  }

  private boolean isHeadingFor(Bird that) {
    float delta = vel.heading() - getDirectionTo(that);
    return abs(delta) < PI;
  }
}