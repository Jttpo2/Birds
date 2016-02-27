class Spermatozoon extends ConsciousEntity {
	static final float MASS = 0.1;
	final color FILL_COLOR = white;
	final color CIRCUMFERENCE_COLOR = grey;

	int bodySize = 10;
	int tailLength = bodySize*2;
	int tailWiggle = tailLength/8;

	PShape body;
	PShape tail;
	PShape sperm;

	float startAngle = 0;
	float angleVel = 0.3;

	Spermatozoon(PVector pos, ArrayList<ConsciousEntity> others) {
   		super(MASS, pos, others);
   		
   		body = createBody();
   		tail = createTail();

   		sperm = createShape(GROUP);
   		sperm.addChild(body);
   		sperm.addChild(tail);
   	}

   	public void display() {
   		pushMatrix();
	    sperm.resetMatrix();
	    sperm.rotate(vel.heading() + PI); 
	    translate(pos.x, pos.y);
	    shape(sperm);
	    popMatrix();
	  }

	void update() {
		super.update();	
		wiggleTail();
	}

	private PShape createBody() {
		ellipseMode(CENTER);
		PShape circle = createShape(ELLIPSE, 0, 0, bodySize, bodySize);
		circle.setFill(FILL_COLOR);
		circle.setStroke(CIRCUMFERENCE_COLOR);
		return circle;
	}

	private PShape createTail() {
		PShape tail = createStaticTail();
		tail.setStroke(grey);
		tail.setFill(false);
		return tail;
	}

	private void wiggleTail() {
		float angle = startAngle;
		for (int i=2; i<tail.getVertexCount(); i++) {
			PVector v = tail.getVertex(i);
			float y = map(sin(angle), -1, 1, -tailWiggle, tailWiggle);
			v.y = y;
			tail.setVertex(i, v.x, v.y);
// 
			angle += angleVel;
		}
		startAngle += 0.2;
		// float x = amplitude * cos(angle);
	}

	private PShape createStaticTail() {
		PShape tail = createShape();
		tail.beginShape();
		// tail.vertex(bodySize, 0);
		float x = bodySize/2;
		float wiggle = tailWiggle; 
		for (float a=0; x<bodySize+tailLength; a+= 0.5) {
			tail.vertex(x, sin(a)*wiggle);
			x+=1;
			wiggle -=0.1;
		}
		tail.endShape();

		return tail;
		
	}

	}
	