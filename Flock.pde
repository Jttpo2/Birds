public class Flock {
	private PVector pos;
	private PVector vel;
	private color baseColor;
	private List<Bird> birds;

	private boolean followMouse = true;

	public Flock(int size) {
		birds = new ArrayList<Bird>();
		Bird bird;

		// for (int i=0; i < sqrt(size); i++) {
		// 	for (int j=0; j < sqrt(size); j++) {
		// 		float x = (width/2/sqrt(size))*i - width;
		// 		float y = (height/2/sqrt(size))*j - height;
		// 		birds.add(new Bird(x, y, birds));
		// 	}
		// }

		// First dash of birds
		for (int i=0; i<size; i++) {
			bird = new Bird(random(width/3, width/2*3), random(height/3, height/2*3), birds);
			birds.add(bird);  
		}
	}

	public void update() {
		int targetX;
		int targetY;
		if (followMouse) {
			targetX = mouseX;
			targetY = mouseY;
		} else {
			targetX = 0;
			targetY = 0;
		}
		for (Bird b : birds) {
			b.update(targetX, targetY);
		}

	}

	public void display() {
		for (Bird b : birds) {
			b.display();
		}
	}

}