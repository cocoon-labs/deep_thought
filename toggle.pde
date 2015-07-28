public class Toggle extends InputDevice {
  
  int radius = 8;

  public Toggle(int pin, int x, int y) {
    super(pin, true, x, y);
  }
  
  void draw() {
    
    ellipseMode(RADIUS);
    if (state == Arduino.LOW) fill(255);
    else fill(255, 0, 0);
    ellipse(xPos, yPos, radius, radius);
    
  }

}
