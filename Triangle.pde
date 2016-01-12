
public class Triangle {
  float triangleWidth;
  float triangleHeight;

    int centerX;
    int centerY;
    float angle;

    // int corner1X;
    // int corner1Y;
    // int corner2X;
    // int corner2Y;
    // int corner3X;
    // int corner3Y;

    public Triangle(int x, int y, float triangleWidth, float triangleHeight, float angle) {
      this.angle = angle;
      moveTo(x, y);

      // corner1X = x;
      // corner1Y = y;

      this.triangleWidth = triangleWidth;
      this.triangleHeight = triangleHeight;

      // setAngle(PI);
    }

    public void setAngle(float angle) {
      this.angle = angle;
      // rotateTo(angle);
    }

    public void moveTo(int x, int y) {
      centerX = x;
      centerY = y;

      // int deltaX = corner1X - x;
      // int deltaY = corner1Y - y;
      // corner1X = x;
      // corner1Y = y;
      // corner2X += deltaX;
      // corner2Y += deltaY;
      // corner3X += deltaX;
      // corner3Y += deltaY;
    }

    private void rotateTo(float angle) {
    // // half top angle of triangle
    //   float alpha = atan((triangleWidth/2) / triangleHeight);
    //   // length of sides
    //   float side = (triangleWidth/2) / sin(alpha);
      
    //   // 2nd corner: angle between right side of triangle and vertical line
    //   float b2 = angle - alpha;
    //   b2 += PI; // Make triangle face Away from mouse
    //   float deltaX2 = side * cos(b2);
    //   float deltaY2 = side * sin(b2);
    //   corner2X = (int) (corner1X + deltaX2);
    //   corner2Y = (int) (corner1Y + deltaY2);

    // // 2nd corner: angle between left side of triangle and vertical line
    //   float b3 = angle + alpha;
    //   b3 += PI; // Make triangle face Away from mouse
    //   float deltaX3 = side * cos(b3);
    //   float deltaY3 = side * sin(b3);
    //   corner3X = (int) (corner1X + deltaX3);
    //   corner3Y = (int) (corner1Y + deltaY3);
    }

    public void display() {
      // 1st corner
      float theta = atan((triangleWidth/2) / triangleHeight);
      float wholeSide = (triangleWidth/2) / sin(theta);
      // float topTriangleSide = (triangleHeight/2) / cos(theta);
      // // float b1 = angle - theta;
      // float b1 = 180 - 90 - angle - theta;
      // float deltaX1 = topTriangleSide * cos(b1);
      // float deltaY1 = topTriangleSide * sin(b1);
      // float corner1X = centerX + deltaX1;
      // float corner1Y = centerY + deltaY1;

      float deltaX1 = (triangleHeight/2)  * cos(angle);
      float deltaY1 = (triangleHeight/2) * sin(angle);
      float corner1X = centerX + deltaX1;
      float corner1Y = centerY + deltaY1;      

      // half mid angle of triangle
      float alpha = atan((triangleWidth/2) / triangleHeight/2);
      // length of sides
      float internalTriangleSide = (triangleWidth/2) / sin(alpha);

      // 2nd corner: angle between right side of triangle and vertical line
      float b2 = angle - alpha;
      b2 += PI; // Make triangle face Away from mouse
      float deltaX2 = internalTriangleSide * cos(b2);
      float deltaY2 = internalTriangleSide * sin(b2);
      float corner2X = centerX + deltaX2;
      float corner2Y = centerY + deltaY2;

    // 2nd corner: angle between left side of triangle and vertical line
      float b3 = angle + alpha;
      b3 += PI; // Make triangle face Away from mouse
      float deltaX3 = internalTriangleSide * cos(b3);
      float deltaY3 = internalTriangleSide * sin(b3);
      float corner3X = centerX + deltaX3;
      float corner3Y = centerY + deltaY3;

    stroke(black);
    fill(black);
    // Angle triangle
    triangle(corner1X, corner1Y, corner2X, corner2Y, corner3X, corner3Y);
    
    fill(white);
    stroke(white);
    rect(centerX, centerY, 1, 1);
    // fill(grey);
    // rect(corner1X, corner1Y, 10, 10);


    }
  }