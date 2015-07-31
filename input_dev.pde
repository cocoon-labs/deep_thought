public abstract class InputDevice {
  
  protected int dataPin;
  public int state;
  protected int reading;
  protected boolean digital;
  public boolean stateChanged = false;
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
    } else {
      reading = arduino.analogRead(dataPin);
    }
    result = reading != state;
    state = reading;
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
