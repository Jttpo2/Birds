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
}