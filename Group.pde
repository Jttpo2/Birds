abstract class Group {
	PVector origin;
	private PVector target;
	ArrayList<ConsciousEntity> entities;

	private boolean followMouse;

	private float xNoiseOffset = random(0, 10000);
	private float yNoiseOffset = random(0, 10000);

	Group(PVector origin, int size, boolean followMouse) {
		// super(origin, size, followMouse);
		this.origin = origin;
		entities = new ArrayList<ConsciousEntity>();

		this.followMouse = followMouse;

		// Perlin noise config.
		int octaves = 2;
		float falloff = 0.9;
		noiseDetail(octaves, falloff);
	}

	void run() {
		if (followMouse) {
			target = new PVector(mouseX, mouseY);
		} else {
			float noiseX = noise(xNoiseOffset);
			float noiseY = noise(yNoiseOffset);
			int x = (int) map(noiseX, 0, 1, 0, width);
			int y = (int) map(noiseY, 0, 1, 0, height);
			target = new PVector(x, y);

			xNoiseOffset += 0.01;
			yNoiseOffset += 0.01;
			
			// fill(black);
			// rectMode(CENTER);
			// rect(x, y, 10, 10);
		}

		for (ConsciousEntity e : entities) {
			e.aimFor(target);
		}

		// super.run();
		superrun();
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

	// ****************************************
	// Should be in ParticleSystem superclass
	void superrun() {
		for (Particle e: entities) {
			e.drag(AIR);
			PVector gravity = new PVector(0, G*e.mass); // Gravitational pull dependent on mass
			e.applyForce(gravity);
			e.run();
		}

		// Iterator<Particle> iter = birds.iterator();
		// while(iter.hasNext()) {
		// 	Particle p = iter.next();
		// 	p.run();
		// 	if (p.isDead()) {
		// 		iter.remove();
		// 	}
		// }
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