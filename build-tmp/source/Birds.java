import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.List; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Birds extends PApplet {


static final boolean devMode = false;
private boolean isRunning = true;
private boolean followMouse = false;

final int BIRD_AMOUNT = 600;
final int FLOCK_AMOUNT = 10;

static final int BIRD_LENGTH = devMode ? 100 : 8;
static final int BIRD_WIDTH = BIRD_LENGTH/2+1;
static final boolean FOLLOW_LEADER = false;
static float topSpeed = devMode ? 3: 7;
static float acceleratorMultiplier = topSpeed*0.07f; // how fast bird changes course towards mouse pointer. Low (0.01) looks like bees. 0.04 kind of like starlings
static float avoidanceEagerness = 0.8f; // low (-1) is nice for lots of small birds. 0.1 seems natural.
static float flyingDistance = BIRD_LENGTH*3;

static final int textSize = 10;

List<Flock> flocks;

final int white = color(255, 255, 255);
final int black = color(0, 0, 0);
final int grey  = color(150, 150, 150);
final int[] hues = {210, 80, 30, 100, 120, 150, 250, 180, 200, 10, 50, 160, 230, 20, 40, 60, 70, 90, 110, 130, 140, 170, 190, 220, 240};

PImage bgImage;

public void setup() {
  // fullScreen(P2D);
    
  //frameRate(1);
  frameRate(40);
  colorMode(HSB, 255, 255, 255);

  bgImage = loadImage("london-skyline[marytaughtme.files.wordpress.com].jpg");
  bgImage.resize(width+3,0);
  textSize(textSize);

  flocks = new ArrayList<Flock>();
  for (int i=0; i<FLOCK_AMOUNT; i++) {
    // flocks.add(new Flock(BIRD_AMOUNT/FLOCK_AMOUNT, hues[i]));
    deployNewFlock();
  }
}

public void draw() {
  if (isRunning) {
    background(white);
    image(bgImage, -3, height-bgImage.height);
    showNumbers();

    for (Flock f: flocks) {
      f.update();
      f.display();
    }
  }
}

private double roundOff(double value) {
  return (double)Math.round(value * 100d) / 100d;
}

public void mousePressed() {
  toggleMouseControl();
}

public void keyPressed() {
  switch (key) {
    case 'a':
    case 'A': 
    topSpeed += 0.5f;
    break;
    case 'z':
    case 'Z': 
    topSpeed -= 0.5f;
    break;
    case 's': 
    case 'S': 
    acceleratorMultiplier += 0.05f;
    break;
    case 'x':
    case 'X': 
    acceleratorMultiplier -= 0.05f;
    break;
    case 'd':
    case 'D': 
    avoidanceEagerness += 0.05f;
    break;
    case 'c': 
    case 'C': 
    avoidanceEagerness -= 0.05f;
    break;
    case 'f':
    case 'F': 
    flyingDistance += 5;
    break;
    case 'v': 
    case 'V': 
    flyingDistance -= 5;
    break;
    case ' ': isRunning = !isRunning;
    break;
  }

  if ('1' <= key && key <= '9') {
    int num = key - '0';
    Flock flock = flocks.get(num);
    flock.toggleFollowMouse();
  }
}

private void showNumbers() {
  fill(grey);
  int initDistance = (int)(width/2.65f);
  text("Speed: " + topSpeed, initDistance, height-textSize);
  text("DirChange: " + roundOff(acceleratorMultiplier), initDistance+75, height-textSize);
  text("Avoidance: " + roundOff(avoidanceEagerness), initDistance+160, height-textSize);
  text("Distance: " + roundOff(flyingDistance), initDistance+250, height-textSize);
  text(PApplet.parseInt(frameRate) + " fps", width-50, height-textSize); 
}

private void deployNewFlock() {
  if (flocks.size() <= FLOCK_AMOUNT && flocks.size() <= hues.length) {
    flocks.add(new Flock(BIRD_AMOUNT/FLOCK_AMOUNT, hues[flocks.size()]));
  }
}

private void toggleMouseControl() {
  for (Flock f: flocks) {
    f.setFollowMouse(!followMouse);
  }
  followMouse = !followMouse;
}
class Bird {
  
  PVector pos;
  PVector vel;
  PVector acc;

  PShape tri;
  int col;

  boolean isLeader = false;
  List<Bird> otherBirds;
  Bird leader;

  // for dramatic entrance
  boolean hasEnteredScreen = false;
 
  public Bird(float x, float y, List<Bird> otherBirds, int col, boolean isLeader) {
   pos = new PVector(x, y);
   vel = PVector.fromAngle(3*PI/2);
   vel.mult(1);


   this.col = col;

   tri = createTriangle();
   tri.translate(pos.x, pos.y);

   this.otherBirds = otherBirds;
   this.isLeader = isLeader;
 }

   public Bird(float x, float y, List<Bird> otherBirds, int col) {
    this(x, y, otherBirds, col, false);
  }  

  public Bird(float x, float y, List<Bird> otherBirds) {
   this(x, y, otherBirds, black, false);
  }

  public void update(PVector target) {  
    
    if (FOLLOW_LEADER && !isLeader) {
      Bird leader = getLeader();
      if (leader != null) {
        target = leader.pos;
      } 
    } 

    aimFor(target);

    avoidCollision();

    updatePos();
    if (hasEnteredScreen) {
      repositionIfOutside();  
    } else {
      checkIfOnscreen();
    }
  }

  // Change course as much as possible towards desired direction
  private void aimFor(PVector targetPos) {
    PVector toTarget = PVector.sub(targetPos, pos);    
    toTarget.normalize();
    toTarget.mult(acceleratorMultiplier);
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
    // Do not overlap vertically
    // if (pos.y > height) {
    //   pos.y = 0;
    // } else if (pos.y < 0) {
    //   pos.y = height;
    // }
  }

  public void display() {
    pushMatrix();
    tri.resetMatrix();
    tri.rotate(vel.heading()); 
    translate(pos.x, pos.y);
    shape(tri);    
    popMatrix();

    // fill(grey);
    // rect(pos.x, pos.y, 2, 2);
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
    if (getDistanceTo(closest) <= flyingDistance) {
      avoid(closest);  
      // println("Avoiding");
    }
  }

  private void avoid(Bird that) {
    if (isHeadingFor(that)) {    
      PVector toBird = PVector.sub(that.pos, this.pos);
      toBird.normalize();
      toBird.mult(-avoidanceEagerness);
      vel.add(toBird);
      vel.limit(topSpeed);

      // float distance = toBird.mag();
      // float newCourse = atan((flyingDistance+1)/ distance);
      // PVector newC = PVector.fromAngle(newCourse);
      // newC.normalize();
      // newC.mult(1);
      // vel.add(newC);
    }
  }

  private boolean isHeadingFor(Bird that) {
    float delta = vel.heading() - getDirectionTo(that);
    return abs(delta) < PI;
  }

  private Bird getLeader() {
    if (leader == null) {
      for (Bird b: otherBirds) {
       if (b.isLeader) {
        leader = b;
        break;
       }
     }  
   }
     return leader;
  }

  // For dramatic entrance
  private void checkIfOnscreen() {
    if (0 < pos.x && pos.x < width &&
      0 < pos.y && pos.y < height) {
      hasEnteredScreen = true;
    }
  }

  private PShape createTriangle() {  
    PShape triangle = createShape(TRIANGLE, BIRD_LENGTH/2, 0, -BIRD_LENGTH/2, -BIRD_WIDTH/2, -BIRD_LENGTH/2, BIRD_WIDTH/2); // Pointing left
    triangle.setFill(col);
    triangle.setStroke(false);
    return triangle;
  }
}
public class Flock {
	private PVector pos;
	private int baseColor;
	private List<Bird> birds;

	private boolean followMouse;

	private float xNoiseOffset = random(0, 10000);
	private float yNoiseOffset = random(0, 10000);

	public Flock(int size, int baseHue, boolean followMouse) {
		birds = new ArrayList<Bird>();
		Bird bird;
		pos = new PVector(random(0, width), height);
		this.followMouse = followMouse;
		baseColor = color(random(baseHue-10, baseHue+10), 255, 255);

		// for (int i=0; i < sqrt(size); i++) {
		// 	for (int j=0; j < sqrt(size); j++) {
		// 		float x = (width/2/sqrt(size))*i - width;
		// 		float y = (height/2/sqrt(size))*j - height;
		// 		birds.add(new Bird(x, y, birds));
		// 	}
		// }

		// First dash of birds
		for (int i=0; i<size; i++) {
			// bird = new Bird(random(width/3, width/2*3), random(height/3, height/2*3), birds, baseColor);
			bird = new Bird(pos.x, pos.y, birds, baseColor);
			birds.add(bird);  
		}

		// Perlin noise config.
		int octaves = 2;
		float falloff = 0.9f;
		noiseDetail(octaves, falloff);
	}

	public Flock(int size, int col) {
		this(size, col, false);
	}

	public Flock(int size) {
		this(size, black);
	}

	public void update() {
		if (followMouse) {
			pos = new PVector(mouseX, mouseY);
		} else {
			float noiseX = noise(xNoiseOffset);
			float noiseY = noise(yNoiseOffset);
			int x = (int) map(noiseX, 0, 1, 0, width);
			int y = (int) map(noiseY, 0, 1, 0, height);
			pos = new PVector(x, y);

			xNoiseOffset += 0.01f;
			yNoiseOffset += 0.01f;
			
			// fill(black);
			// rectMode(CENTER);
			// rect(x, y, 10, 10);
		}
		for (Bird b : birds) {
			b.update(pos);
		}

	}

	public void setFollowMouse(boolean state) {
		followMouse = state;
	}

	public void toggleFollowMouse() {
		setFollowMouse(!followMouse);
	}

	public void display() {
		for (Bird b : birds) {
			b.display();
		}
	}

}
  public void settings() {  size(925, 750, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Birds" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
