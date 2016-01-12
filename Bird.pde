class Bird {
  private static final float MAX_COURSE_CHANGE = PI/60;

  float xPos;
  float yPos;

  float velocity;
  float direction; // radians

  Triangle triangle;

  List<Bird> otherBirds;

  boolean followMouse = true;

  float maxPi = 0;
  float minPi = 0;
 
  public Bird(float x, float y, List<Bird> otherBirds) {
    xPos = x;
    yPos = y;
    velocity = 2;
    direction = PI/2;

    triangle = new Triangle((int) xPos, (int) yPos, 20, 40, direction);
    this.otherBirds = otherBirds;
  }

  public void update() {
    float desiredDirection;
    if (followMouse) {
      desiredDirection = calculateAngle(xPos, yPos, mouseX, mouseY);  
    } else {
      Bird closest = findClosest(otherBirds);
      desiredDirection = getDirectionTo(closest);
    }
    

    // Change course as much as possible towards desired direction
    float directionDelta = desiredDirection - direction;
    println(" current: " + direction/PI + " Desired: " + desiredDirection/PI + " Delta: " + directionDelta);

    // 1st and 4th quadrant wrong direction loop prevention
    // if ((direction > PI && desiredDirection < 0) ||
    //  direction < 0 && desiredDirection > 0) {
    //   directionDelta = -directionDelta;
    // } 

    if (directionDelta >= 0) {
      rotate(min(directionDelta, MAX_COURSE_CHANGE));
    } else {
      rotate(max(directionDelta, -MAX_COURSE_CHANGE));
    }

    // // Handle angle overflow
    // if (direction >= 1.5*PI) {
    //   direction -= 2*PI;
    // } else if (direction <= 0.5*PI) {
    //   direction += 2*PI;
    // }

    // if (desiredDirection/PI > maxPi) {
    //   maxPi = desiredDirection/PI;
    // }
    // if (desiredDirection/PI < minPi) {
    //   minPi = desiredDirection/PI;
    // } 
    // println("max: " + maxPi + " min: " + minPi);
    // if (direction > 2*PI) {
    //   direction = -PI;
    // } else if (direction < PI) {
    //   direction = 2*PI;
    // } 

    updatePos();
    repositionIfOutside();
    triangle.moveTo((int) xPos, (int) yPos);
    triangle.setAngle(direction);
  }

  private void rotate(float radians) {
    setDirection(direction + radians);
  }

  private void setDirection(float angle) {
    direction = angle;
    // Overflow handling
    if (direction > 1.5*PI) {
      direction = -0.5*PI + (direction % 2*PI);
    } else if (direction < -0.5*PI) {
      direction = 1.5*PI - (direction % 2*PI);
    }
  }

  private void updatePos() {
    float deltaX = velocity * cos(direction);  // radians(direction));
    float deltaY = velocity * sin(direction);  // radians(direction));
    xPos += deltaX;
    yPos += deltaY;
  }

  // Angle between points in radians
  private float calculateAngle(float x1, float y1, float x2, float y2) {
    float deltaX = x2-x1;
    float deltaY = y2-y1;
    // prevent division by 0
    float angle;
    if (deltaX == 0) {
      if (y2 > y1) {
        angle = PI/2;
      } else{
        angle = -PI/2;
      }
    } else if (deltaX > 0) {
      // 1st and 4th quadrant
      angle = atan(deltaY/deltaX);
    } else {
      // 2nd and 4th quadrant
      angle = PI + atan(deltaY/deltaX);
    }

    return angle;
  }

  private void repositionIfOutside() {
    if (xPos > width) {
      xPos = 0;
    } else if (xPos < 0) {
      xPos = width;
    }
    if (yPos > height) {
      yPos = 0;
    } else if (yPos < 0) {
      yPos = height;
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

    float angleToBird = calculateAngle(this.xPos, this.yPos, that.xPos, that.yPos);
    println("to bird: " + angleToBird);
    return angleToBird;
  }

  private float getDistanceTo(Bird that) {
    float deltaX = that.xPos-this.xPos;
    float deltaY = that.yPos-this.yPos;
    return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
  }

  private Bird findClosest(List<Bird> otherBirds) {
    float distanceToClosest = Float.MAX_VALUE;
    Bird closest = null;
    for (Bird that: otherBirds) {
      float distance = getDistanceTo(that);
      if (distance < distanceToClosest) {
        distanceToClosest = distance;
        closest = that;
      }
    }
    return closest;
  }
}