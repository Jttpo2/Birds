class Particle {
	PVector pos;
	PVector vel;
	PVector acc;
	
	int radius;
	float mass;
	// float lifeSpan;

	boolean overlapVertically = true;

	// for dramatic entrance
  	boolean hasEnteredScreen = false;

	Particle(float mass, PVector pos) {
		this.pos = pos.get();
		
		float randX = random(-1, 1);
		float randY = random(-1, 1);
		vel = new PVector(randX, randY);
		acc = new PVector(0,0);
		radius = 5;
		this.mass = mass;
		// lifespan = 255.0;
	}

	void update() {
		// vel.limit(topSpeed);
		vel.add(acc);
		pos.add(vel);
		acc.mult(0); // clear acceleration
		// lifespan -= 2.0;

		if (hasEnteredScreen) {
      		checkBounds();  
    	} else {
      		checkIfOnscreen();
    	}
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
		PVector f = PVector.div(force, mass);
		acc.add(force);
	}

	void drag(Liquid l) {
	    float speed = vel.mag(); // Speed of object
	    float a = 1; // Frontal area of object
	    PVector drag = vel.get(); // Velocity unit vector
	    drag.normalize();

	    float dragMagnitude = l.c * a * speed * speed;
	    drag.mult(-1);
	    drag.mult(dragMagnitude);
    	applyForce(drag);
    }

	boolean isDead() {
		// return lifespan < 0;
		return false;
	}

	private void checkBounds() {
	    if (pos.x > width) {
	      pos.x = 0;
	    } else if (pos.x < 0) {
	      pos.x = width;
	    }
	    
	    if (overlapVertically) {
		    if (pos.y > height) {
		      pos.y = 0;
		    } else if (pos.y < 0) {
		      pos.y = height;
		    }
	    }
	  }
	  
	  // For dramatic entrance
	  void checkIfOnscreen() {
	    if (0 < pos.x && pos.x < width &&
	      0 < pos.y && pos.y < height) {
	      hasEnteredScreen = true;
	    }
	  }
}
