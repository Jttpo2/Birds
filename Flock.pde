class Flock {
	private PVector pos;
	private color baseColor;
	private ArrayList<Bird> birds;

	private boolean followMouse;

	private float xNoiseOffset = random(0, 10000);
	private float yNoiseOffset = random(0, 10000);

	public Flock(int size, int baseHue, boolean followMouse) {
		birds = new ArrayList<Bird>();
		Bird bird;
		pos = new PVector(random(0, width), height);
		this.followMouse = followMouse;
		baseColor = color(random(baseHue-10, baseHue+10), 255, 255);

		// for (int i=0; i < sqrt(size); i++) {
		// 	for (int j=0; j < sqrt(size); j++) {
		// 		float x = (width/2/sqrt(size))*i - width;
		// 		float y = (height/2/sqrt(size))*j - height;
		// 		birds.add(new Bird(x, y, birds));
		// 	}
		// }

		// First dash of birds
		for (int i=0; i<size; i++) {
			// bird = new Bird(random(width/3, width/2*3), random(height/3, height/2*3), birds, baseColor);
			bird = new Bird(pos.x, pos.y, birds, baseColor);
			birds.add(bird);  
		}

		// Perlin noise config.
		int octaves = 2;
		float falloff = 0.9;
		noiseDetail(octaves, falloff);
	}

	public Flock(int size, color col) {
		this(size, col, false);
	}

	public Flock(int size) {
		this(size, black);
	}

	public void update() {
		if (followMouse) {
			pos = new PVector(mouseX, mouseY);
		} else {
			float noiseX = noise(xNoiseOffset);
			float noiseY = noise(yNoiseOffset);
			int x = (int) map(noiseX, 0, 1, 0, width);
			int y = (int) map(noiseY, 0, 1, 0, height);
			pos = new PVector(x, y);

			xNoiseOffset += 0.01;
			yNoiseOffset += 0.01;
			
			// fill(black);
			// rectMode(CENTER);
			// rect(x, y, 10, 10);
		}
		for (Bird b : birds) {
			b.update(pos);
		}

	}

	public void setFollowMouse(boolean state) {
		followMouse = state;
	}

	public void toggleFollowMouse() {
		setFollowMouse(!followMouse);
	}

	public void display() {
		for (Bird b : birds) {
			b.display();
		}
	}

}