class Bird extends ConsciousEntity {
  // PShape tri;
  color col;

  PVector[] vertices = new PVector[3];

  // ArrayList<ConsciousEntity> otherBirds;
 
  public Bird(float mass, PVector pos, ArrayList<ConsciousEntity> otherBirds, color col) {
   super(mass, pos, otherBirds);

   this.col = col;

   // tri = createTriangle();
   // tri.translate(pos.x, pos.y);

   createTriangle();

   // this.otherBirds = otherBirds;
 }

  // public Bird(PVector pos, ArrayList<ConsciousEntity> otherBirds) {
  //  this(1, pos, otherBirds, black);
  // }

  @Override
  public void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    pushMatrix();
    // resetMatrix();
    // tri.resetMatrix();
    // tri.rotate(vel.heading()); 
    rotate(vel.heading()); 
    
    // shape(tri);
    noStroke();
    fill(col);
    beginShape();
    for (int i=0; i<vertices.length; i++) {
      PVector v = vertices[i];
      vertex(v.x, v.y);
    }
    endShape();    
    popMatrix();
    popMatrix();

    // fill(grey);
    // rect(pos.x, pos.y, 2, 2);
  }

  // private PShape createTriangle() {  
  //   PShape triangle = createShape(TRIANGLE, BIRD_LENGTH/2, 0, -BIRD_LENGTH/2, -BIRD_WIDTH/2, -BIRD_LENGTH/2, BIRD_WIDTH/2); // Pointing left
  //   triangle.setFill(col);
  //   triangle.setStroke(false);
  //   return triangle;
  // }

  private void createTriangle() {
    vertices[0] = new PVector(BIRD_LENGTH/2, 0);
    vertices[1] = new PVector(-BIRD_LENGTH/2, -BIRD_WIDTH/2);
    vertices[2] = new PVector(-BIRD_LENGTH/2, BIRD_WIDTH/2);
  }
}
