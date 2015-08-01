public abstract class InputDevice {
  
  protected int dataPin;
  public int state;
  protected int reading;
  protected boolean digital;
  public boolean stateChanged = false;
  protected int tolerance = 5;
  int xPos, yPos;

  public InputDevice(int pin, boolean digital, int xPos, int yPos) {
    this.digital = digital;
    arduino.pinMode(pin, Arduino.INPUT);
    dataPin = pin;
    recordState();
    this.xPos = xPos;
    this.yPos = yPos;
  }
  
  public InputDevice() {
  }

  public boolean recordState() {
    boolean result = false;
    if (digital) {
      reading = arduino.digitalRead(dataPin);
      result = reading != state;
      state = reading;
    } else {
      reading = arduino.analogRead(dataPin);
      result = abs(reading - state) >= tolerance;
      if (result) state = reading;
    }
    stateChanged = result;
    if (stateChanged) sleeper.trigger();
    return result;
  }

  public int getState() {
    return state;
  }
  
  void draw() {
    
  }
}
