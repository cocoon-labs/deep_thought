public class Joystick {

  public int C = 0, U = 1, D = 2, L = 3, R = 4;
  public int UL = 5, UR = 6, DL = 7, DR = 8;

  private int[] dataPins;
  private int[] state;
  private int[] reading;
  public boolean stateChanged;
  
  
  int x, y;
  int radius = 20;

  public Joystick(int up, int down, int left, int right, int x, int y) {
    
    arduino.pinMode(up, Arduino.INPUT);
    arduino.pinMode(down, Arduino.INPUT);
    arduino.pinMode(left, Arduino.INPUT);
    arduino.pinMode(right, Arduino.INPUT);
    
    // set pull-up resistors. NB: Now LOW means a direction is engaged
    arduino.digitalWrite(up, Arduino.HIGH);
    arduino.digitalWrite(down, Arduino.HIGH);
    arduino.digitalWrite(left, Arduino.HIGH);
    arduino.digitalWrite(right, Arduino.HIGH);

    dataPins = new int[] {up, down, left, right};
    reading = new int[dataPins.length];
    state = new int[dataPins.length];
    recordState();
    
    this.x = x;
    this.y = y;
  }

  public boolean recordState() {
    boolean result = false;
    for (int i = 0; i < dataPins.length; i++) {
      reading[i] = arduino.digitalRead(dataPins[i]);
      result = result || (reading[i] != state[i]);
      state[i] = reading[i];
    }
    stateChanged = result;
    return result;
  }

  public int getState(int dir) {
    int tmp = state[dir - 1];
    return tmp == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
  }

  public int getDirection() {
    int result = C;
    if (getState(U) == Arduino.HIGH && getState(L) == Arduino.HIGH) {
      result = UL;
    } else if (getState(U) == Arduino.HIGH && getState(R) == Arduino.HIGH) {
      result = UR;
    } else if (getState(D) == Arduino.HIGH && getState(L) == Arduino.HIGH) {
      result = DL;
    } else if (getState(U) == Arduino.HIGH && getState(R) == Arduino.HIGH) {
      result = DR;
    } else if (getState(U) == Arduino.HIGH) {
      result = U;
    } else if (getState(D) == Arduino.HIGH) {
      result = D;
    } else if (getState(L) == Arduino.HIGH) {
      result = L;
    } else if (getState(R) == Arduino.HIGH) {
      result = R;
    }
    return result;
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    ellipseMode(RADIUS);
    fill(255);
    ellipse(0, 0, radius, radius);
    float angle;
    boolean off = false;
    if (state[0] != 0 && state[1] != 0 && state[2] != 0 && state[3] != 0) {
      fill(0);
      ellipse (0, 0, radius/2, radius/2);
    } else {
      if (state[0] == 0) {
        if (state[2] == 0) angle = -PI/4;
        else if (state[3] == 0) angle = PI/4;
        else angle = 0;
      } else if (state[1] == 0) {
        if (state[2] == 0) angle = -3 * PI/4;
        else if (state[3] == 0) angle = 3 * PI/4;
        else angle = PI;
      } else if (state[2] == 0) angle = -PI/2;
      else angle = PI/2;
      rotate(angle);
      fill(255, 0, 0);
      ellipse (0, -radius/2, radius/2, radius/2);
    }
    popMatrix();
  }
}
