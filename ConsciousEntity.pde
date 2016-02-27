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
    // Check for proximity every 3rd frame
    if (frameCount % 3  == 0) {
      // think(otherEntities);  
    }

    PVector flockingVector = flock(otherEntities);
    // acc.add(flockingVector);
    aimFor(flockingVector);


    super.update();
  }

  private void think(ArrayList<ConsciousEntity> others) {
    avoidCollision(others);
  }

	private ConsciousEntity findClosest(ArrayList<ConsciousEntity> others) {
    float distanceToClosest = 1000000; // Float.MAX_VALUE; Does not exist in processing.js
    ConsciousEntity closest = null;
    for (ConsciousEntity that: others) {
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

  void avoidCollision(ArrayList<ConsciousEntity> others) {
    ConsciousEntity closest = findClosest(others);
    if (closest == null) {
      return;
    }
    if (getDistanceTo(closest) <= flyingDistance) {
      avoid(closest);  
    }
  }

  private final float MAX_SPEED_DISTANCE = 50;
  private final float DAMPING = 100;
  private final float MAX_FORCE = 4;

  // Change course as much as possible towards desired direction
  public void aimFor(PVector targetPos) {
    PVector toTarget = PVector.sub(targetPos, pos);    
    toTarget.normalize();
    // toTarget.mult(acceleratorMultiplier);

    float dist = toTarget.mag();
    if (dist < MAX_SPEED_DISTANCE) {
      toTarget.mult(topSpeed*(dist/DAMPING));
    } else {
      toTarget.mult(topSpeed);
    }
    toTarget.limit(MAX_FORCE);
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


  private final float SEPARATION_WEIGHT = 1;
  private final float ALIGNMENT_WEIGHT = 1;
  private final float COHESION_WEIGHT = 0.5;
  private final float NEIGHBOUR_RADIUS = 200;

  private PVector flock(ArrayList<ConsciousEntity> others) {
    PVector separation = separate(others);
    separation.mult(SEPARATION_WEIGHT);
    PVector alignment = align(others);
    alignment.mult(ALIGNMENT_WEIGHT);
    PVector cohesion = cohere(others);
    cohesion.mult(COHESION_WEIGHT);
    
    cohesion.add(alignment);
    cohesion.add(separation);
    // separation.add(cohesion);
    // return separation;
    return cohesion;
  }

  private PVector separate(ArrayList<ConsciousEntity> others) {
    PVector mean = new PVector();
    for (ConsciousEntity e: others) {
      float dist = getDistanceTo(e);
      if (0 <  dist && dist < flyingDistance) {
        PVector toEntity = PVector.sub(this.pos, e.pos);
        // toEntity.normalize();
        // toEntity.div(dist);
        // toEntity.mult(-1);

        mean.add(toEntity);
      }
    }
    // mean.limit(MAX_FORCE);


    return mean;
  }

  private PVector align(ArrayList<ConsciousEntity> others) {
    PVector mean = new PVector();
    for (ConsciousEntity e: others) {
      if (0 < getDistanceTo(e) && getDistanceTo(e) < NEIGHBOUR_RADIUS) {
        mean.add(e.vel);
      }
    }
    mean.limit(MAX_FORCE);

    return mean;
  }

  private PVector cohere(ArrayList<ConsciousEntity> others) {
    PVector sum = new PVector();
    for (ConsciousEntity e: others) {
      if (0 < getDistanceTo(e) && getDistanceTo(e) < NEIGHBOUR_RADIUS) {
        sum.add(e.pos);
      }
    }
    return sum;
  }
}
