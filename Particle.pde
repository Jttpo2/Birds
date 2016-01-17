class Particle {
	PVector pos;
	PVector vel;
	PVector acc;
	
	int radius;
	float mass;
	// float lifeSpan;

	ArrayList<Particle> otherParticles;

	Particle(float mass, PVector pos, ArrayList<Particle> otherParticles) {
		this.pos = pos.copy();
		vel = new PVector();
		acc = new PVector(0,0);
		radius = 5;
		this.mass = mass;
		// lifespan = 255.0;
		this.otherParticles = otherParticles;
	}

	void update() {
		vel.limit(topSpeed);
		vel.add(acc);
		pos.add(vel);
		acc.mult(0); // clear acceleration
		// lifespan -= 2.0;
	}

	void display() {
		noStroke();
		// fill(col, lifespan);
		fill(0);
		ellipseMode(CENTER);
		ellipse(pos.x, pos.y, radius, radius);

	}

	void run() {
		update();
		display();
	}

	void applyForce(PVector force) {
		// PVector f = force.copy();
		// f.div(mass);
		PVector f = PVector.div(force, mass);
		acc.add(force);
	}

	boolean isDead() {
		// return lifespan < 0;
		return false;
	}

 private Particle findClosest() {
    float distanceToClosest = Float.MAX_VALUE;
    Particle closest = null;
    for (Particle that: otherParticles) {
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
    Particle closest = findClosest();
    if (closest == null) {
      return;
    }
    if (getDistanceTo(closest) <= flyingDistance) {
      avoid(closest);  
      // println("Avoiding");
    }
  }

  // Change course as much as possible towards desired direction
  public void aimFor(PVector targetPos) {
    PVector toTarget = PVector.sub(targetPos, pos);    
    toTarget.normalize();
    toTarget.mult(acceleratorMultiplier);
    applyForce(toTarget);


    // acc = toTarget;
    // vel.add(acc);
    // vel.limit(topSpeed);
  }

  private void avoid(Particle that) {
    if (isHeadingFor(that)) {    
      PVector toParticle = PVector.sub(that.pos, this.pos);
      toParticle.normalize();
      toParticle.mult(-avoidanceEagerness);
      vel.add(toParticle);
      vel.limit(topSpeed);

      // float distance = toBird.mag();
      // float newCourse = atan((flyingDistance+1)/ distance);
      // PVector newC = PVector.fromAngle(newCourse);
      // newC.normalize();
      // newC.mult(1);
      // vel.add(newC);
    }
  }

  private float getDirectionTo(Particle that) {
    PVector between = PVector.sub(that.pos, this.pos);
    float angleToParticle = between.heading();
    return angleToParticle;
  }

  private PVector getVectorTo(Particle that) {
    return PVector.sub(that.pos, this.pos);
  }

  private float getDistanceTo(Particle that) {
    PVector between = PVector.sub(that.pos, this.pos);
    return between.mag();
  }

  private boolean isHeadingFor(Particle that) {
    float delta = vel.heading() - getDirectionTo(that);
    return abs(delta) < PI;
  }
}