public class DistanceBeam {
  
  int xPos = 325;
  int yPos = 899;
  int radius = 7;
  
  public int state = 0;
  public boolean stateChanged = false;
  int tolerance = 1;
  
  
  public DistanceBeam() {
    
  }
  
  public boolean recordState(int reading) {
    boolean result = false;
    result = abs(reading - state) >= tolerance;
    if (result) state = reading;
    stateChanged = result;
    if (stateChanged) sleeper.trigger();
    return result;
  }
  
  public int getState() {
    return state;
  }
  
  void draw() {
    
    ellipseMode(RADIUS);
    int red = state;
    fill(red, 0, 0);
    ellipse(xPos, yPos, radius, radius);
    
  }

}
