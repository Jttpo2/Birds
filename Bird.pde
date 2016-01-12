class Bird {
  private static final float MAX_COURSE_CHANGE = PI/60;
  private static final float FLYING_DISTANCE = 100;

  // float xPos;
  // float yPos;
  PVector pos;
  PVector vel;

  // float velocity;
  // float direction; // radians

  Triangle triangle;

  List<Bird> otherBirds;

  boolean followMouse = true;

  float maxPi = 0;
  float minPi = 0;
 
  public Bird(float x, float y, List<Bird> otherBirds) {
    pos = new PVector(x, y);
    vel = new PVector(1, 1);
    vel.mult(2);
    
    // xPos = x;
    // yPos = y;
    // velocity = 2;
    // direction = PI/2;
    triangle = new Triangle((int) pos.x, (int) pos.y, 20, 40, vel.heading());
    this.otherBirds = otherBirds;
  }

  public void update() {
    float desiredDirection;
    if (followMouse) {
      PVector mousePos = new PVector(mouseX, mouseY);
      // desiredDirection = calculateAngle(pos.x, pos.y, mouseX, mouseY);  
      PVector between = PVector.sub(mousePos, this.pos);
      desiredDirection = between.heading();
    } else {
      Bird closest = findClosest();
      desiredDirection = getDirectionTo(closest);
    }
    aimFor(desiredDirection);
    
    avoidCollision();
    
    updatePos();
    repositionIfOutside();
    triangle.moveTo((int) pos.x, (int) pos.y);
    triangle.setAngle(vel.heading());
  }

  // Change course as much as possible towards desired direction
  private void aimFor(float desiredDirection) {
    float directionDelta = desiredDirection - vel.heading();
    // directionDelta
    println(" current: " + vel.heading()/PI + " Desired: " + desiredDirection/PI + " Delta: " + directionDelta/PI);

    // Quadrant wrong direction loop prevention
    int q = getQuadrant(vel.heading());
    // println("q: " + q);
    if (
      q == 1 && directionDelta > PI ||
      q == 4 && directionDelta < -PI ||
      q == 2 && directionDelta > PI ||
      q == 3 && directionDelta < -PI 
     ) {
      // rotationAngle = 2*PI - rotationAngle;
      directionDelta = -directionDelta;
    } 

    if (directionDelta >= 0) {
      rotate(min(directionDelta, MAX_COURSE_CHANGE));
    } else {
      rotate(max(directionDelta, -MAX_COURSE_CHANGE));
    }
  }

  // Helper for extracting quadrant from angle
  private int getQuadrant(float angle) {
    angle = angle % (2*PI);

    if (0 <= angle && angle < PI/2 ) {
      return 1;
    } else if (PI/2 <= angle && angle < PI) {
      return 2;
    } else if (PI <= angle && angle < 3*PI/2) {
      return 3;
    } else if (3*PI/2 <= angle && angle < 2*PI) {
      return 4;
    } else {
      println("Outside standard quadrants");
      return -1;
    }
  }

  private void rotate(float radians) {
    // setDirection(vel.heading() + radians);
    vel.rotate(radians);
  }

  // Set exact flying direction
  // private void setDirection(float angle) {
  //   // Overflow handling
  //   angle = angle % (2*PI);
  //   if (angle < 0) {
  //     angle += 2*PI;
  //   } 
  //   direction = angle; 
  // }

  // Update position from course and velocity
  private void updatePos() {
    pos.add(vel);

    // float deltaX = velocity * cos(direction);  // radians(direction));
    // float deltaY = velocity * sin(direction);  // radians(direction));
    // xPos += deltaX;
    // yPos += deltaY;
  }

  // Angle between points in radians
  // private float calculateAngle(float x1, float y1, float x2, float y2) {
  //   float deltaX = x2-x1;
  //   float deltaY = y2-y1;
  //   // prevent division by 0
  //   float angle;
  //   if (deltaX == 0) {
  //     if (y2 > y1) {
  //       angle = PI/2;
  //     } else{
  //       angle = -PI/2;
  //     }
  //   } else {
  //     angle = atan(deltaY/deltaX);
  //     if (deltaX >= 0) {
  //       if (deltaY >= 0) {
  //         // 1st
  //         // leave it be
  //       } else {
  //         // 4th
  //         angle = 2*PI + angle;
  //       }
  //     } else {
  //         // 2nd & 3rd
  //         angle = PI + angle;
  //     }
  //   } 

  //   return angle;
  // }

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
    if (that == null) {
      println("No bird to fly towards");
      return 0;
    }

    // float angleToBird = calculateAngle(this.xPos, this.yPos, that.xPos, that.yPos);
    PVector between = PVector.sub(that.pos, this.pos);
    float angleToBird = between.heading();
    println("to bird: " + angleToBird);
    return angleToBird;
  }

  private float getDistanceTo(Bird that) {
    PVector between = PVector.sub(that.pos, this.pos);
    return between.mag();
    // float deltaX = that.xPos-this.xPos;
    // float deltaY = that.yPos-this.yPos;
    // return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
  }

  private Bird findClosest() {
    float distanceToClosest = Float.MAX_VALUE;
    Bird closest = null;
    // println("Flock: " + otherBirds.size());
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
      float newDirection = atan((FLYING_DISTANCE/2)/getDistanceTo(that));
      aimFor(newDirection);  
    }
  }

  private boolean isHeadingFor(Bird that) {
    float delta = vel.heading() - getDirectionTo(that);
    if (abs(delta) < PI) {
      println(this + " Heading for " + that);
      return true;
    } else {
      return false;
    }
  }
}