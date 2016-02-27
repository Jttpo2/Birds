abstract class Group {
	PVector origin;
	private PVector target;
	ArrayList<ConsciousEntity> entities;

	private boolean followMouse;

	private float xNoiseOffset = random(0, 10000);
	private float yNoiseOffset = random(0, 10000);

	boolean gravityEnabled = false;
	boolean airResistanceEnabled = true;

	Group(PVector origin, int size, boolean followMouse) {
		// super(origin, size, followMouse);
		this.origin = origin;
		entities = new ArrayList<ConsciousEntity>();

		this.followMouse = followMouse;

		// Perlin noise config.
		int octaves = 2;
		float falloff = 1.5;
		noiseDetail(octaves, falloff);
	}

	void run() {
		if (frameCount % 2 == 0) {
			if (followMouse) { // && !isMouseIdle()) {
				target = new PVector(mouseX, mouseY);
			} else {
				target = getPerlinNoisePoint();
			}

			for (ConsciousEntity e : entities) {
				e.aimFor(target); // Working at making them autonomous
			}

		}
		// super.run();
		superrun();
	}

	private PVector getPerlinNoisePoint() {
		float noiseX = noise(xNoiseOffset);
		float noiseY = noise(yNoiseOffset);
		int x = (int) map(noiseX, 1.1, 2, 0, width/2);
		int y = (int) map(noiseY, 1.1, 2, 0, height/2);
		// int x = (int) map(noiseX, 0, 1, 0, width/2); // something weird with perlin noise in js
		// int y = (int) map(noiseY, 0, 1, 0, height/2);// something weird with perlin noise in js

		xNoiseOffset += 0.01;
		yNoiseOffset += 0.01;
		
		// Show where they're heading
		// fill(black);
		// rectMode(CENTER);
		// rect(x, y, 10, 10);
		
		return new PVector(x, y);
	}

	void addEntity(ConsciousEntity e) {
		entities.add(e);  
	}

	void setFollowMouse(boolean state) {
		followMouse = state;
	}

	void toggleFollowMouse() {
		setFollowMouse(!followMouse);
	}

	int getSize() {
		return entities.size();
	}

	boolean isMouseWithinCanvas() {
			return !(mouseX <= 0 || mouseX >= width || mouseY <= 0 || mouseY >= height);
	}

	// long lastMouseCheckTime = millis();
	// long mouseCheckInterval = 1000*2;
	// int oldMouseX = mouseX;
	// int oldMouseY = mouseY;
	// boolean isMouseIdle() {
	// 	if (lastMouseCheckTime + mouseCheckInterval < millis()) {
	// 		boolean inSamePos = isInSamePos();
	// 		oldMouseX = mouseX;
	// 		oldMouseY = mouseY;
	// 		lastMouseCheckTime = millis();
	// 		return inSamePos;
	// 	} else return false;
	// }

	// boolean isInSamePos() {
	// 	return mouseX == oldMouseX && mouseY == oldMouseY;
	// }

	// ****************************************
	// Should be in ParticleSystem superclass
	void superrun() {
		for (Particle e: entities) {
			if (airResistanceEnabled) {
				e.drag(AIR);
			}
			if (gravityEnabled) {
				PVector gravity = new PVector(0, G*e.mass); // Gravitational pull dependent on mass
				e.applyForce(gravity);
			}
			e.run();
		}
	}

	// Should be in ParticleSystem superclass
	void applyForce(PVector force) {
		for (Particle e: entities) {
			e.applyForce(force);
		}
	}

	// Should be in ParticleSystem superclass
	void applyRepeller(Repeller r) {
		for (Particle e: entities) {
			PVector force = r.repel(e);
			e.applyForce(force);
		}
	}

	// Should be in ParticleSystem superclass
	void applyAttractor(Attractor a) {
		for (Particle e: entities) {
			PVector force = a.attract(e);
			e.applyForce(force);
		}
	}

}
