class Bird {
  float xPos;
  float yPos;

  float velocity;
  float direction; // radians

  Triangle triangle;

  List<Bird> otherBirds;

  boolean followMouse = false;

  public Bird(float x, float y, List<Bird> otherBirds) {
    xPos = x;
    yPos = y;
    velocity = 2;
    direction = PI/2;

    triangle = new Triangle((int) xPos, (int) yPos, 100, 200, direction);
    this.otherBirds = otherBirds;
  }

  public void update() {
    if (followMouse) {
      direction = calculateAngle(xPos, yPos, mouseX, mouseY);  
    } else {
      Bird closest = findClosest(otherBirds);
      goTowards(closest);
    }
    updatePos();
    repositionIfOutside();
    triangle.moveTo((int) xPos, (int) yPos);
    triangle.setAngle(direction);
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

  private void goTowards(Bird that) {
    if (that == null) {
      println("No bird to fly towards");
      return;
    }

    float angleToBird = calculateAngle(this.xPos, this.yPos, that.xPos, that.yPos);
    println("to bird: " + angleToBird);
    direction = angleToBird;
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