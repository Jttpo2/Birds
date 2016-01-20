class ParticleSystem {
	ArrayList<Particle> particles;
	PVector origin;

	private static final float STANDARD_MASS = 1;

	ParticleSystem(PVector origin) {
		this.origin = origin.get();
		particles = new ArrayList<Particle>();
	}

	// void addParticle() { // Processing.js has issues with different lengths of parameter lists for same function
	// 	particles.add(new Particle(STANDARD_MASS, origin));
	// }

	void addParticle(Particle p) {
		particles.add(p);
	}

	void removeParticle(Particle p) {
		particles.remove(p);
	}

	void run() {
		for (Particle p: particles) {
			p.drag(AIR);
			PVector gravity = new PVector(0, G*p.mass); // Gravitational pull dependent on mass
			p.applyForce(gravity);
			p.run();
		}
	}

	void applyForce(PVector force) {
		for (Particle p: particles) {
			p.applyForce(force);
			// TODO Apply gravitational force (gravity = new PVector(0,0.1); applyForce(gravity)) force in main
		}
	}

	void applyAttractor(Attractor a) {
		for (Particle p: particles) {
			PVector force = a.attract(p);
			p.applyForce(force);
		}
	}

	void applyRepeller(Repeller r) {
		for (Particle p: particles) {
			PVector force = r.repel(p);
			p.applyForce(force);
		}
	}
}