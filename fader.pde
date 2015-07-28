public class Fader extends InputDevice {
  
  int h = 5;
  int w = 15;
  // x,y references the bottom point.
  
  public Fader(int pin, int x, int y) {
    super(pin, false, x, y);
  }
  
  void draw() {
    rectMode(CENTER);
    float val = map(state, 0, 1023, 0, 1);
    int actualY = (int) (yPos - 40 * val);
    fill(0);
    rect(xPos, actualY, w, h);
  }
}
