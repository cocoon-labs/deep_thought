public class Matrix {
  //Modes:
  // 0/1: Presets (Modes vs Colors)
  // 2/3: WC (White vs Color gradients)
  // 4: Direct Control (On/Off)
  // 5: Arcade Mode (On/Off)
  // 6: Mind Fuck (On/Off)

  int MODE_PRESETS = 0;
  int COLOR_PRESETS = 1;
  int COLOR_GRAD = 2;
  int WHITE_GRAD = 3;
  int DIRECT_CONTROL = 4;
  int ARCADE = 5;
  int MINDFUCK = 6;
  
  int redundancy = 1;
  
  int mode = COLOR_PRESETS;
  int prev_mode = -1;
  int lastSend = millis();

  public Matrix() {
    mode = 0;
    update();
    determineMode();
    updateMode();
  }

  public void update() {
    for (int i = 0; i < panel.toggles.length; i++) {
      if (panel.toggles[i].stateChanged) {
        determineMode();
      }
    }
    if (mode != prev_mode) {
      updateMode();
    }

    prev_mode = mode;

    if (panel.coin.getState() == Arduino.HIGH) {
      acceptCoin();
    }

    if (key == CODED) {
      int stick1 = 0;
      int stick2 = 0;
      if (keyCode == UP) {
        stick1 = -1;
      } else if (keyCode == DOWN) {
        stick1 = 1;
      } 
      if (keyCode == RIGHT) {
        stick2 = -1;
      } else if (keyCode == LEFT) {
        stick2 = 1;
      }
      sendJoysticks(stick1, stick2);
      key = '9';
    }
  }

  public void determineMode() {
    if (panel.toggles[T_DEST].getState() == Arduino.HIGH) {
      mode = MINDFUCK;
    } else if (panel.toggles[T_DC].getState() == Arduino.HIGH) {
      mode = DIRECT_CONTROL;
    } else if (panel.toggles[T_ARCADE].getState() == Arduino.HIGH) {
      mode = ARCADE;
    } else if (panel.toggles[T_PRESETS].getState() == Arduino.HIGH) {
      mode = MODE_PRESETS;
    } else if (panel.toggles[T_WC].getState() == Arduino.HIGH) {
      mode = WHITE_GRAD;
    } else {
      mode = COLOR_PRESETS;
    }

  }

  public void updateMode() {
    for (int i = 0; i < redundancy; i++) {
      OscMessage message;
      message = new OscMessage("/mode");
      message.add(mode);
      oscP5.send(message, myRemoteLocation);
    }
  }

  // TODO: update this to send all joysticks
  public void sendJoysticks(int s1, int s2) {
    if (millis() - lastSend > 100) {
      OscMessage message;
      message = new OscMessage("/js");
      
      message.add(s1);
      message.add(s2);

      oscP5.send(message, myRemoteLocation);
      lastSend = millis();
    }
  }

  public void acceptCoin() {
    OscMessage message;
    message = new OscMessage("/coin");
    oscP5.send(message, myRemoteLocation);
  }

  public void sendColor(float[] c) {
    OscMessage message;
    message = new OscMessage("/color");
    message.add(c[0]);
    message.add(c[1]);
    message.add(c[2]);
    oscP5.send(message, myRemoteLocation);
  }

}
