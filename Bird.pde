class Bird extends ConsciousEntity {
  color col;

  PVector[] vertices = new PVector[3];
 
  public Bird(float mass, PVector pos, ArrayList<ConsciousEntity> otherBirds, color col) {
   super(mass, pos, otherBirds);
   this.col = col;

   createTriangle();
 }

  @Override
  public void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    pushMatrix();
    rotate(vel.heading()); 
    
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
  }

  private void createTriangle() {
    vertices[0] = new PVector(BIRD_LENGTH/2, 0);
    vertices[1] = new PVector(-BIRD_LENGTH/2, -BIRD_WIDTH/2);
    vertices[2] = new PVector(-BIRD_LENGTH/2, BIRD_WIDTH/2);
  }
}
