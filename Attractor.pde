class Attractor {
	float mass;
	PVector pos;

	float minWorkingDistance;
	float maxWorkingDistance;

	float sizeMultiplier = 0.005;

	Attractor(PVector pos, float mass) {
		this.pos = pos;
		this.mass = mass;
		minWorkingDistance = mass/850;
		maxWorkingDistance = mass/100;
	}

	void display() {
		noStroke();
		fill(grey);
		ellipseMode(CENTER);
		ellipse(pos.x, pos.y, mass*sizeMultiplier, mass*sizeMultiplier);
	}

	PVector attract(Particle p) {
		PVector force = PVector.sub(this.pos, p.pos);
		float distance = force.mag();
		distance = constrain(distance, minWorkingDistance, maxWorkingDistance);
		force.normalize();
		float strength = (G * mass * p.mass) / (distance * distance);
		force.mult(strength);
		// println(strength);
		return force;
	}
}