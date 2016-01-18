class Ejaculation extends Group {
	
	Ejaculation(PVector origin, int size, boolean followMouse) {
		super(origin, size, followMouse);

		for (int i=0; i<size; i++) {
			addSpermatozoon();
		}
	}

	public void addSpermatozoon() {
		super.addEntity(new Spermatozoon(origin, entities));  
	}
}