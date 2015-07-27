public class Pot extends InputDevice {
  
  int radius = 8;
   
  public Pot(int pin, int x, int y) {
    super(pin, false, x, y);
  }
  
  void draw() {
    pushMatrix();
    ellipseMode(RADIUS);
    fill(255);
    translate(xPos, yPos);
    ellipse(0, 0, radius, radius);
    float angle = map(state, 0, 1023, -5 * PI / 6, 5 * PI / 6);
    rotate(angle);
    rectMode(CENTER);
    fill(0);
    rect(0, -radius/2, radius/5, radius);
    popMatrix();
  }

}
