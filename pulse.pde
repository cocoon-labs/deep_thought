public class Pulse extends InputDevice {
  
  int radius = 7;
  
  public Pulse(int pin, int x, int y) {
    super(pin, false, x, y);
  }
  
  void draw() {
    
    ellipseMode(RADIUS);
    int red = (int) map(state, 0, 1023, 0, 255);
    fill(red, 0, 0);
    ellipse(xPos, yPos, radius, radius);
    
  }

}
