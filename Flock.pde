import java.util.Iterator;

class Flock { // extends ParticleSystem {
	private PVector origin;
	private PVector target;
	private color baseColor;
	private ArrayList<ConsciousEntity> birds;

	private boolean followMouse;

	private float xNoiseOffset = random(0, 10000);
	private float yNoiseOffset = random(0, 10000);

	private final float STANDARD_MASS = 1;

	public Flock(PVector origin, int size, int baseHue, boolean followMouse) {
		// super(origin);]
		this.origin = origin;
		// birds = particles;
		birds = new ArrayList<ConsciousEntity>();
		
		this.followMouse = followMouse;
		baseColor = color(random(baseHue-10, baseHue+10), 255, 255);

		Bird bird;
		for (int i=0; i<size; i++) {
			addBird();
		}

		// Perlin noise config.
		int octaves = 2;
		float falloff = 0.9;
		noiseDetail(octaves, falloff);
	}

	public Flock(PVector origin, int size, color col) {
		this(origin, size, col, false);
	}

	public Flock(PVector origin, int size) {
		this(origin, size, black);
	}

	public void addBird() {
		birds.add(new Bird(STANDARD_MASS, origin, birds, baseColor));  
	}

	public void run() {
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

		for (ConsciousEntity b : birds) {
			PVector gravity = new PVector(0, G*b.mass); // Gravitational pull dependent on mass
			b.drag(AIR);
			b.applyForce(gravity);
			b.aimFor(target);
		}

		// super.run();
		superrun();
	}

	public void setFollowMouse(boolean state) {
		followMouse = state;
	}

	public void toggleFollowMouse() {
		setFollowMouse(!followMouse);
	}

	// *********** Should be in ParticleSystem ***********
	// void addParticle() {
	// 	particles.add(new Particle(STANDARD_MASS, origin, particles));
	// }

	// void addParticle(Particle p) {
	// 	particles.add(p);
	// }

	// void removeParticle(Particle p) {
	// 	particles.remove(p);
	// }

	// ParticleSystem
	void superrun() {
		Iterator<ConsciousEntity> iter = birds.iterator();
		while(iter.hasNext()) {
			ConsciousEntity p = iter.next();
			p.run();
			if (p.isDead()) {
				iter.remove();
			}
		}
	}

	// ParticleSystem
	void applyForce(PVector force) {
		for (Particle p: birds) {
			p.applyForce(force);
			// TODO Apply gravitational force (gravity = new PVector(0,0.1); applyForce(gravity)) force in main
		}
	}

	// ParticleSystem
	void applyRepeller(Repeller r) {
		for (Particle p: birds) {
			PVector force = r.repel(p);
			p.applyForce(force);
		}
	}

	// ParticleSystem
	void applyAttractor(Attractor a) {
		for (Particle p: birds) {
			PVector force = a.attract(p);
			p.applyForce(force);
		}
	}
}