class Bird {
  
  PVector pos;
  PVector vel;
  PVector acc;

  PShape tri;
  color col;

  boolean isLeader = false;
  List<Bird> otherBirds;
  Bird leader;

  // for dramatic entrance
  boolean hasEnteredScreen = false;
 
  public Bird(float x, float y, List<Bird> otherBirds, boolean isLeader) {
    pos = new PVector(x, y);
    vel = PVector.fromAngle(3*PI/2);
    vel.mult(1);

    // color col = black;
    // color col = color(50, random(0, 255), 30);
    // color col = color(random(0, 40));
    col = color(random(240,255), 255, 255);

    tri = createTriangle();
    tri.translate(pos.x, pos.y);

    this.otherBirds = otherBirds;
    this.isLeader = isLeader;

  }

  public Bird(float x, float y, List<Bird> otherBirds) {
    this(x, y, otherBirds, false);
  }

  public void update() {  
    PVector target; 
    if (FOLLOW_LEADER) {
      if (isLeader) {
        target = new PVector(mouseX, mouseY);
      } else {
        Bird l = getLeader();
        if (l != null) {
          target = l.pos;
        } else {
          target = new PVector(mouseX, mouseY);
        }
      }
    } else {
      target = new PVector(mouseX, mouseY);
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
      toBird.mult(avoidanceEagerness);
      vel.add(toBird);

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
