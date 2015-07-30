public class CoinAcceptor extends InputDevice {

  int pulseLen;
  
  public CoinAcceptor(int pin, int pulseLen, int x, int y) {
    super();
    this.digital = true;
    arduino.pinMode(pin, Arduino.INPUT);
    arduino.digitalWrite(pin, Arduino.HIGH); // pull-up resistor
    dataPin = pin;
    xPos = x;
    yPos = y;
    this.pulseLen = pulseLen;
  }

  public boolean recordState() {
    boolean result = false;
    int counter = 0;
    reading = arduino.digitalRead(dataPin);

    while (reading == Arduino.HIGH) {
      delay(1);
      counter += 1;
      reading = arduino.digitalRead(dataPin);
    }

    if (counter >= pulseLen) 
      reading = Arduino.HIGH;
    else reading = Arduino.LOW;

    result = reading != state;
    state = reading;
    stateChanged = result;
    return result;
  }
}
