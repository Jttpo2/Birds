import java.util.Iterator;

class ParticleSystem {
	ArrayList<Particle> particles;
	PVector origin;

	private static final float STANDARD_MASS = 1;

	ParticleSystem(PVector pos) {
		origin = pos.copy();
		particles = new ArrayList<Particle>();
	}

	void addParticle() {
		particles.add(new Particle(STANDARD_MASS, origin));
	}

	void run() {
		Iterator<Particle> iter = particles.iterator();
		while(iter.hasNext()) {
			Particle p = iter.next();
			p.run();
			if (p.isDead()) {
				iter.remove();
			}
		}
	}

	void applyForce(PVector force) {
		for (Particle p: particles) {
			p.applyForce(force);
			// TODO Apply gravitational force (gravity = new PVector(0,0.1); applyForce(gravity)) force in main
		}
	}

	void applyRepeller(Repeller r) {
		for (Particle p: particles) {
			PVector force = r.repel(p);
			p.applyForce(force);
		}
	}
}