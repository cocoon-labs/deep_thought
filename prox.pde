public class Proximity extends InputDevice {
  
  int radius = 15;
  
  public Proximity(int pin, int x, int y) {
    super(pin, true, x, y);
  }
  
  void draw() {
    
    ellipseMode(RADIUS);
    if (state == 0) fill(255);
    else fill(255, 0, 0);
    ellipse(xPos, yPos, radius, radius);
    
  }

}
