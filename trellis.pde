public class Trellis {
  
  int nColorPresets = 0;
  int nModePresets = 0;
  
  public boolean stateChanged = false;
  boolean isSleeping;
  
  // general mode options
  int mode;
  int SCREENSAVER = 0;
  int MODES = 1;
  int COLORS = 2;
  int ARCADE = 3;
  int SLEEP = 4;
  
  // serial tags
  int SWITCHMODE = 0;
  int MODESEL = 1;
  int COLORSEL = 2;
  int BEAMVAL = 3;
  
  Serial port;
  DistanceBeam beam;
  
  public Trellis(Serial port) {
    this.port = port;
    port.clear();
    wake();
    beam = new DistanceBeam();
  }
  
  void init() {
    determineMode();
    sendMode();
  }
  
  void wake() {
    isSleeping = false;
    init();
  }
  
  void sleep() {
    isSleeping = true;
    clearScreen();
  }
  
  void check() {
    if (!isSleeping) {
      checkToggles();
      recordState();
    }
  }
  
  void checkToggles() {
    boolean changed = false;
    if (panel.toggles[T_PRESETS].stateChanged ||
        panel.toggles[T_DC].stateChanged ||
        panel.toggles[T_ARCADE].stateChanged ||
        panel.toggles[T_DEST].stateChanged) {
      updateMode();
    }
  }
  
  void updateMode() {
    if (determineMode()) sendMode();
  }

  boolean determineMode() {
    int newMode = mode;
    if (panel.toggles[T_DEST].getState() == Arduino.HIGH) {
      newMode = SCREENSAVER;
    } else if (panel.toggles[T_DC].getState() == Arduino.HIGH) {
      newMode = SCREENSAVER;
    } else if (panel.toggles[T_ARCADE].getState() == Arduino.HIGH) {
      newMode = ARCADE;
    } else if (panel.toggles[T_PRESETS].getState() == Arduino.HIGH) {
      newMode = MODES;
    } else {
      newMode = COLORS;
    }
    boolean modeChanged = mode != newMode;
    mode = newMode;
    return modeChanged;
  }
  
  void sendMode() {
    port.write(SWITCHMODE);
    port.write(mode);
    if (mode == MODES) {
      port.write(field.modes.length);
    } else if (mode == COLORS) {
      port.write(wheel.presets.length);
    }
  }
  
  boolean recordState() {
    boolean result = false;
    if (port.available() > 0) {
      int firstByte = port.read();
      if (firstByte == BEAMVAL) {
        if (port.available() > 0) {
          beam.recordState(port.read());
        }        
      } else if (firstByte == MODESEL) {
        if (port.available() > 0) {
          int modeSelected = port.read();
          selectModePreset(modeSelected);
          result = true;
        }
      } else if (firstByte == COLORSEL) {
        if (port.available() > 0) {
          int colorSelected = port.read();
          selectColorPreset(colorSelected);
          result = true;
        }
      } else {
        port.clear();
      }
      stateChanged = result;
      if (stateChanged) sleeper.trigger();
    }
    return result;
  }
  
  void clearScreen() {
    port.write(SWITCHMODE);
    port.write(SLEEP);
  }
  
  // Called when color preset is selected via Trellis
  void selectColorPreset(int c) {
    wheel.setPreset(c);
  }
  
  // Called when mode preset is selected via Trellis
  void selectModePreset(int m) {
    field.setMode(m);
  }
  
  void draw() {
    beam.draw();
  }
  
}
