public abstract class InputDevice {
  
  protected int dataPin;
  protected int state;
  protected int reading;
  protected boolean digital;

  public InputDevice(int pin, boolean digital) {
    this.digital = digital;
    arduino.pinMode(pin, Arduino.INPUT);
    dataPin = pin;
    recordState();
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
    return result;
  }

  public int getState() {
    return state;
  }
}
