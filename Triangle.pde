
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
    }

    public void moveTo(int x, int y) {
      centerX = x;
      centerY = y;
    }

    public void display() {
      // 1st corner
      float theta = atan((triangleWidth/2) / triangleHeight);
      float deltaX1 = (triangleHeight/2)  * cos(angle);
      float deltaY1 = (triangleHeight/2) * sin(angle);
      float corner1X = centerX + deltaX1;
      float corner1Y = centerY + deltaY1;      

      // half mid angle of triangle
      float alpha = atan((triangleWidth) / triangleHeight);
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
    
    // fill(white);
    // stroke(white);
    // rect(centerX, centerY, 1, 1);
    // fill(grey);
    // rect(corner1X, corner1Y, 10, 10);


    }
  }