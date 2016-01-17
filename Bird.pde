class Bird extends Particle {
  // float mass;

  // PVector pos;
  // PVector vel;
  // PVector acc;

  PShape tri;
  color col;

  boolean isLeader = false;
  ArrayList<Particle> otherBirds;
  Bird leader;

  // for dramatic entrance
  boolean hasEnteredScreen = false;
 
  public Bird(float mass, PVector pos, ArrayList<Particle> otherBirds, color col, boolean isLeader) {
   super(mass, pos, otherBirds);

   // this.mass = mass;
   // pos = new PVector(x, y);
   // vel = PVector.fromAngle(3*PI/2);
   // vel.mult(1);


   this.col = col;

   tri = createTriangle();
   tri.translate(pos.x, pos.y);

   this.otherBirds = otherBirds;
   this.isLeader = isLeader;
 }

   public Bird(float mass, PVector pos, ArrayList<Particle> otherBirds, color col) {
    this(mass, pos, otherBirds, col, false);
  }  

  public Bird(PVector pos, ArrayList<Particle> otherBirds) {
   this(1, pos, otherBirds, black);
  }

  // public void update(PVector target) {  
  public void update() {  
    
    // if (FOLLOW_LEADER && !isLeader) {
    //   Bird leader = getLeader();
    //   if (leader != null) {
    //     target = leader.pos;
    //   } 
    // } 


    // aimFor(target);


    avoidCollision();
    super.update();
    
    if (hasEnteredScreen) {
      repositionIfOutside();  
    } else {
      checkIfOnscreen();
    }
  }

  // // Change course as much as possible towards desired direction
  // public void aimFor(PVector targetPos) {
  //   PVector toTarget = PVector.sub(targetPos, pos);    
  //   toTarget.normalize();
  //   toTarget.mult(acceleratorMultiplier);
  //   applyForce(toTarget);


  //   // acc = toTarget;
  //   // vel.add(acc);
  //   // vel.limit(topSpeed);
  // }

  // // Update position from course and velocity
  // private void updatePos() {
  //   pos.add(vel);
  // }

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
