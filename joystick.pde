public class Joystick {

  public int C = 0, U = 1, D = 2, L = 3, R = 4;
  public int UL = 5, UR = 6, DL = 7, DR = 8;

  private int[] dataPins;
  private int[] state;
  private int[] reading;

  public Joystick(int up, int down, int left, int right) {
    
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
  }

  public boolean recordState() {
    boolean result = false;
    for (int i = 0; i < dataPins.length; i++) {
      reading[i] = arduino.digitalRead(dataPins[i]);
      result = result || (reading[i] != state[i]);
      state[i] = reading[i];
    }
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
}
