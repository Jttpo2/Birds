import java.util.Iterator;

class Flock extends Group { // extends ParticleSystem {
	private static final float STANDARD_BIRD_MASS =1;
	private color baseColor;

	public Flock(PVector origin, int size, int baseHue, boolean followMouse) {
		super(origin, size, followMouse);
		
		baseColor = color(random(baseHue-10, baseHue+10), 255, 255);

		for (int i=0; i<size; i++) {
			addBird();
		}
	}

	public Flock(PVector origin, int size, color col) {
		this(origin, size, col, false);
	}

	public Flock(PVector origin, int size) {
		this(origin, size, black);
	}

	public void addBird() {
		super.addEntity(new Bird(STANDARD_BIRD_MASS, origin, particles, baseColor));  
	}
}