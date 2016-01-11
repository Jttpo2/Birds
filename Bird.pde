class Bird {
  float xPos;
  float yPos;
  // float triangleLength;
  // float triangleWidth;

  float velocity;
  float direction; // radians

  Triangle triangle;

  public Bird(float x, float y) {
    xPos = x;
    yPos = y;
    velocity = 2;
    direction = PI/2;

    triangle = new Triangle((int) xPos, (int) yPos, 100, 200, direction);
  }

  public void update() {
    // Go towards mouse
    direction = calculateAngle(xPos, yPos, mouseX, mouseY);
    println(direction);
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

  // Angle between points in degrees
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
}