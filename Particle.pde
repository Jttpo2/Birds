class Particle {
	PVector pos;
	PVector vel;
	PVector acc;
	
	int radius;
	float mass;
	// float lifeSpan;

	Particle(float mass, PVector pos) {
		this.pos = pos.copy();
		vel = new PVector();
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
    PVector drag = vel.copy().normalize(); // Velocity unit vector

    float dragMagnitude = l.c * a * speed * speed;
    drag.mult(-1);
    drag.mult(dragMagnitude);
    applyForce(drag);
  }

	boolean isDead() {
		// return lifespan < 0;
		return false;
	}
}