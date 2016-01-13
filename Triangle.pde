
public class Triangle {
  float triangleWidth;
  float triangleHeight;

  PShape shape;

  PVector pos;
  PVector angle;

  public Triangle(int x, int y, float triangleWidth, float triangleHeight, PVector angle) {
    this.angle = angle;
    pos = new PVector(x, y);

    this.triangleWidth = triangleWidth;
    this.triangleHeight = triangleHeight;
  }

  public void setAngle(PVector angle) {
    this.angle = angle;
  }

  public void moveTo(int x, int y) {
    pos.x = x;
    pos.y = y;
  }

  public void display() {
    // 1st corner
    float theta = atan((triangleWidth/2) / triangleHeight);
    float deltaX1 = (triangleHeight/2)  * cos(angle.heading());
    float deltaY1 = (triangleHeight/2) * sin(angle.heading());
    float corner1X = pos.x + deltaX1;
    float corner1Y = pos.y + deltaY1;      

    // half mid angle of triangle
    float alpha = atan((triangleWidth) / triangleHeight);
    // length of sides
    float internalTriangleSide = (triangleWidth/2) / sin(alpha);

    // 2nd corner: angle between right side of triangle and vertical line
    float b2 = angle.heading() - alpha;
    b2 += PI; // Make triangle face Away from mouse
    float deltaX2 = internalTriangleSide * cos(b2);
    float deltaY2 = internalTriangleSide * sin(b2);
    float corner2X = pos.x + deltaX2;
    float corner2Y = pos.y + deltaY2;

  // 2nd corner: angle between left side of triangle and vertical line
    float b3 = angle.heading() + alpha;
    b3 += PI; // Make triangle face Away from mouse
    float deltaX3 = internalTriangleSide * cos(b3);
    float deltaY3 = internalTriangleSide * sin(b3);
    float corner3X = pos.x + deltaX3;
    float corner3Y = pos.y + deltaY3;

  stroke(black);
  fill(black);
  triangle(corner1X, corner1Y, corner2X, corner2Y, corner3X, corner3Y);
  }
}