public class Trellis {
  
  int nColorPresets = 0;
  int nModePresets = 0;
  
  public boolean stateChanged = false;
  
  // general mode options
  int mode;
  int SCREENSAVER = 0;
  int MODES = 1;
  int COLORS = 2;
  int ARCADE = 3;
  
  // serial tags
  int SWITCHMODE = 0;
  int COLORPRESET = 1;
  int MODEPRESET = 2;
  
  Serial port;
  
  public Trellis(Serial port) {
    this.port = port;
    port.clear();
  }
  
  void init() {
    determineMode();
    sendMode();
  }
  
  void check() {
    checkToggles();
    recordState();
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
    if (mode == ARCADE) {
      if (port.available() > 0) {
        int inByte = port.read();
        
        // DO STUFF
        result = true;
      }
    } else if (mode == MODES) {
      if (port.available() > 0) {
        int modeSelected = port.read();
        selectModePreset(modeSelected);
        result = true;
      }
    } else if (mode == COLORS) {
      if (port.available() > 0) {
        int colorSelected = port.read();
        selectColorPreset(colorSelected);
        result = true;
      }
    }
    stateChanged = result;
    return result;
  }
  
  // Called when color preset is selected via Trellis
  void selectColorPreset(int c) {
    wheel.setPreset(c);
  }
  
  // Called when mode preset is selected via Trellis
  void selectModePreset(int m) {
    field.setMode(m);
  }
  
  void selectModeOption(int optionSelected) {
    // field.setModeOption(optionSelected);
    // OR SOMETHING LIKE THAT
  }
}
