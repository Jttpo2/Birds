class Flock extends ParticleSystem {
	private PVector target;
	private color baseColor;
	private ArrayList<Particle> birds;

	private boolean followMouse;

	private float xNoiseOffset = random(0, 10000);
	private float yNoiseOffset = random(0, 10000);

	private final float STANDARD_MASS = 1;

	public Flock(PVector origin, int size, int baseHue, boolean followMouse) {
		super(origin);
		birds = particles;
		
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

		for (Particle b : birds) {
			PVector gravity = new PVector(0, G*b.mass); // Gravitational pull dependent on mass
			b.drag(AIR);
			b.applyForce(gravity);
			b.aimFor(target);
		}

		super.run();
	}

	public void setFollowMouse(boolean state) {
		followMouse = state;
	}

	public void toggleFollowMouse() {
		setFollowMouse(!followMouse);
	}
}