
public class Triangle {
  float triangleWidth;
  float triangleHeight;

    int corner1X;
    int corner1Y;
    int corner2X;
    int corner2Y;
    int corner3X;
    int corner3Y;

    public Triangle(int x, int y, float triangleWidth, float triangleHeight, float angle) {
      corner1X = x;
      corner1Y = y;

      this.triangleWidth = triangleWidth;
      this.triangleHeight = triangleHeight;

      setAngle(PI);
    }

    public void setAngle(float angle) {
      rotateTo(angle);
    }

    public void moveTo(int x, int y) {
      int deltaX = corner1X - x;
      int deltaY = corner1Y - y;
      corner1X = x;
      corner1Y = y;
      corner2X += deltaX;
      corner2Y += deltaY;
      corner3X += deltaX;
      corner3Y += deltaY;
    }

    private void rotateTo(float angle) {
    // half top angle of triangle
      float alpha = atan((triangleWidth/2) / triangleHeight);
      // length of sides
      float side = (triangleWidth/2) / sin(alpha);
      
      // 2nd corner: angle between right side of triangle and vertical line
      float b2 = angle - alpha;
      b2 += PI; // Make triangle face Away from mouse
      float deltaX2 = side * cos(b2);
      float deltaY2 = side * sin(b2);
      corner2X = (int) (corner1X + deltaX2);
      corner2Y = (int) (corner1Y + deltaY2);

    // 2nd corner: angle between left side of triangle and vertical line
      float b3 = angle + alpha;
      b3 += PI; // Make triangle face Away from mouse
      float deltaX3 = side * cos(b3);
      float deltaY3 = side * sin(b3);
      corner3X = (int) (corner1X + deltaX3);
      corner3Y = (int) (corner1Y + deltaY3);
    }

    public void display() {
    stroke(black);
    fill(black);
    // Angle triangle
    triangle(corner1X, corner1Y, corner2X, corner2Y, corner3X, corner3Y);
    }
  }