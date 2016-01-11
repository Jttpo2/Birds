import java.util.List;

List<Bird> birds;

color white = color(255, 255, 255);
color black = color(0, 0, 0);
color grey  = color(150, 150, 150);

void setup() {
  size(800, 600);
  background(grey);

  birds = new ArrayList<Bird>();
  Bird bird = new Bird(width/2, height/2);
  birds.add(bird);
}

void draw() {
  background(grey);
  
  for (Bird b: birds) {
  	b.update();
  	b.display();
  }
}

class Bird {
  int xPos;
  int yPos;
  // float triangleLength;
  // float triangleWidth;

  float velocity;
  float direction; // radians

  Triangle triangle;

  public Bird(int x, int y) {
  	xPos = x;
  	yPos = y;
  	velocity = 2;
  	direction = PI/2;

  	triangle = new Triangle(xPos, yPos, 100, 200, direction);
  }

  public void update() {
  	// Go towards mouse
  	direction = calculateAngle(xPos, yPos, mouseX, mouseY);
  	println(direction);
  	updatePos();
  	repositionIfOutside();
  	triangle.moveTo(xPos, yPos);
  	triangle.setAngle(direction);
  }

  private void updatePos() {
  	float deltaX = velocity * cos(direction);	// radians(direction));
  	float deltaY = velocity * sin(direction);	// radians(direction));
  	xPos += deltaX;
  	yPos += deltaY;
  }

  // Angle between points in degrees
  private float calculateAngle(int x1, int y1, int x2, int y2) {
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
  	// stroke(black);
   //  fill(black);
   //  // Angle triangle
  	// triangle(xPos, yPos, xPos-triangleWidth/2, yPos+triangleLength, xPos+triangleWidth/2, yPos+triangleLength);
  	triangle.display();
  }

  
}

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