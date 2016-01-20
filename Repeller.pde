class Repeller {
	PVector pos;
	float radius;
	float strength;

	int minWorkingDistance = 5;
	int maxWorkingDistance = 100;


	Repeller(PVector pos) {
		this.pos = pos.get();
		radius = 5;
		strength = 100;
	}

	void display() {
		noStroke();
		fill(0);
		ellipseMode(CENTER);
		ellipse(pos.x, pos.y, radius, radius);
	}

	PVector repel(Particle p) {
		PVector dir = PVector.sub(this.pos, p.pos);
		float distance = dir.mag();
		distance = constrain(distance, minWorkingDistance, maxWorkingDistance);
		dir.normalize();
		float force = -1 * strength / (distance * distance);
		dir.mult(force);
		return dir;
	}
}