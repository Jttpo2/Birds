class Particle {
	PVector pos;
	PVector vel;
	PVector acc;
	
	color col;
	int radius;
	float mass;
	// float lifeSpan;

	Particle(PVector pos) {
		this.pos = pos.copy();
		vel = new PVector();
		acc = new PVector(0,0);
		col = color(0);
		radius = 5;
		mass = 1;
		// lifespan = 255.0;
	}

	void update() {
		vel.add(acc);
		pos.add(vel);
		acc.mult(0); // clear acceleration
		// lifespan -= 2.0;
	}

	void display() {
		noStroke();
		// fill(col, lifespan);
		fill(col);
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