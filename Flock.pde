import java.util.Iterator;

class Flock extends Group { // extends ParticleSystem {
	private static final float STANDARD_BIRD_MASS =1;
	private color baseColor;

	public Flock(PVector origin, int size, int baseHue, boolean followMouse) {
		super(origin, size, followMouse);
		// this.origin = origin;
		// birds = particles;
		// birds = new ArrayList<ConsciousEntity>();
		
		// this.followMouse = followMouse;
		baseColor = color(random(baseHue-10, baseHue+10), 255, 255);

		for (int i=0; i<size; i++) {
			addBird();
		}

		// Perlin noise config.
		// int octaves = 2;
		// float falloff = 0.9;
		// noiseDetail(octaves, falloff);
	}

	public Flock(PVector origin, int size, color col) {
		this(origin, size, col, false);
	}

	public Flock(PVector origin, int size) {
		this(origin, size, black);
	}

	public void addBird() {
		super.addEntity(new Bird(STANDARD_BIRD_MASS, origin, entities, baseColor));  
	}

	// public void run() {
	// 	if (followMouse) {
	// 		target = new PVector(mouseX, mouseY);
	// 	} else {
	// 		float noiseX = noise(xNoiseOffset);
	// 		float noiseY = noise(yNoiseOffset);
	// 		int x = (int) map(noiseX, 0, 1, 0, width);
	// 		int y = (int) map(noiseY, 0, 1, 0, height);
	// 		target = new PVector(x, y);

	// 		xNoiseOffset += 0.01;
	// 		yNoiseOffset += 0.01;
			
	// 		// fill(black);
	// 		// rectMode(CENTER);
	// 		// rect(x, y, 10, 10);
	// 	}

	// 	for (ConsciousEntity b : birds) {
	// 		b.aimFor(target);
	// 	}

	// 	// super.run();
	// 	superrun();
	// }

	// public void setFollowMouse(boolean state) {
	// 	followMouse = state;
	// }

	// public void toggleFollowMouse() {
	// 	setFollowMouse(!followMouse);
	// }

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

	// // ParticleSystem
	// void superrun() {
	// 	for (Particle p: birds) {
	// 		p.drag(AIR);
	// 		PVector gravity = new PVector(0, G*p.mass); // Gravitational pull dependent on mass
	// 		p.applyForce(gravity);
	// 		p.run();
	// 	}

	// 	// Iterator<Particle> iter = birds.iterator();
	// 	// while(iter.hasNext()) {
	// 	// 	Particle p = iter.next();
	// 	// 	p.run();
	// 	// 	if (p.isDead()) {
	// 	// 		iter.remove();
	// 	// 	}
	// 	// }
	// }

	// // ParticleSystem
	// void applyForce(PVector force) {
	// 	for (Particle p: birds) {
	// 		p.applyForce(force);
	// 		// TODO Apply gravitational force (gravity = new PVector(0,0.1); applyForce(gravity)) force in main
	// 	}
	// }

	// // ParticleSystem
	// void applyRepeller(Repeller r) {
	// 	for (Particle p: birds) {
	// 		PVector force = r.repel(p);
	// 		p.applyForce(force);
	// 	}
	// }

	// // ParticleSystem
	// void applyAttractor(Attractor a) {
	// 	for (Particle p: birds) {
	// 		PVector force = a.attract(p);
	// 		p.applyForce(force);
	// 	}
	// }
}