class ConsciousEntity extends Particle {
	ArrayList<ConsciousEntity> otherEntities;

	ConsciousEntity(float mass, PVector pos, ArrayList<ConsciousEntity> otherEntities) {
	// ciousEntity(float mass, PVector pos) {
		super(mass, pos);
		this.otherEntities = otherEntities;
		// if (otherEntities == null) {
		// 	otherEntities = new ArrayList<ConsciousEntity>();
		// }
	}

  void update() {
    avoidCollision();
    super.update();
  }

	private ConsciousEntity findClosest() {
    float distanceToClosest = 1000000; // Float.MAX_VALUE; Does not exist in processing.js
    ConsciousEntity closest = null;
    for (ConsciousEntity that: otherEntities) {
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

  void avoidCollision() {
    ConsciousEntity closest = findClosest();
    if (closest == null) {
      return;
    }
    if (getDistanceTo(closest) <= flyingDistance) {
      avoid(closest);  
    }
  }

  // Change course as much as possible towards desired direction
  public void aimFor(PVector targetPos) {
    PVector toTarget = PVector.sub(targetPos, pos);    
    toTarget.normalize();
    toTarget.mult(acceleratorMultiplier);
    applyForce(toTarget);
  }

  private void avoid(ConsciousEntity that) {
    if (isHeadingFor(that)) {    
      PVector toParticle = PVector.sub(that.pos, this.pos);
      toParticle.normalize();
      toParticle.mult(-avoidanceEagerness);
      vel.add(toParticle);
      // vel.limit(topSpeed);
    }
  }

  private float getDirectionTo(ConsciousEntity that) {
    PVector between = PVector.sub(that.pos, this.pos);
    float angleToParticle = between.heading();
    return angleToParticle;
  }

  private PVector getVectorTo(ConsciousEntity that) {
    return PVector.sub(that.pos, this.pos);
  }

  private float getDistanceTo(ConsciousEntity that) {
    PVector between = PVector.sub(that.pos, this.pos);
    return between.mag();
  }

  private boolean isHeadingFor(ConsciousEntity that) {
    float delta = vel.heading() - getDirectionTo(that);
    return abs(delta) < PI;
    // return getVectorTo(that).dot(vel) >= 0;
  }
}
