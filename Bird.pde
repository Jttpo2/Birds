class Bird extends ConsciousEntity {
  PShape tri;
  color col;

  // ArrayList<ConsciousEntity> otherBirds;
 
  public Bird(float mass, PVector pos, ArrayList<ConsciousEntity> otherBirds, color col) {
   super(mass, pos, otherBirds);

   this.col = col;

   tri = createTriangle();
   tri.translate(pos.x, pos.y);

   // this.otherBirds = otherBirds;
 }

  public Bird(PVector pos, ArrayList<ConsciousEntity> otherBirds) {
   this(1, pos, otherBirds, black);
  }

  @Override
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

  private PShape createTriangle() {  
    PShape triangle = createShape(TRIANGLE, BIRD_LENGTH/2, 0, -BIRD_LENGTH/2, -BIRD_WIDTH/2, -BIRD_LENGTH/2, BIRD_WIDTH/2); // Pointing left
    triangle.setFill(col);
    triangle.setStroke(false);
    return triangle;
  }
}
