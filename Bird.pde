class Bird extends ConsciousEntity {
  PShape tri;
  color col;

  boolean isLeader = false;
  ArrayList<ConsciousEntity> otherBirds;
  Bird leader;

  // for dramatic entrance
  boolean hasEnteredScreen = false;
 
  public Bird(float mass, PVector pos, ArrayList<ConsciousEntity> otherBirds, color col, boolean isLeader) {
   super(mass, pos, otherBirds);

   this.col = col;

   tri = createTriangle();
   tri.translate(pos.x, pos.y);

   this.otherBirds = otherBirds;
   this.isLeader = isLeader;
 }

   public Bird(float mass, PVector pos, ArrayList<ConsciousEntity> otherBirds, color col) {
    this(mass, pos, otherBirds, col, false);
  }  

  public Bird(PVector pos, ArrayList<ConsciousEntity> otherBirds) {
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

    avoidCollision();
    super.update();
    
    if (hasEnteredScreen) {
      repositionIfOutside();  
    } else {
      checkIfOnscreen();
    }
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
