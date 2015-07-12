public class Trellis {
  
  // general mode options
  int mode;
  int SCREENSAVER = 0;
  int PRESETS = 1;
  int SPECS = 2;
  int ARCADE = 3;
  
  // specific mode options
  int specsMode;
  
  // serial tags
  int SWITCHMODE = 0;
  int COLORPRESET = 1;
  int MODEPRESET = 2;
  
  Serial port;
  
  public Trellis(Serial port) {
    this.port = port;
    updateMode();
  }
  
  void updateMode() {
    determineMode();
    sendMode();
  }

  void determineMode() {
    if (toggles[T_DEST].getState() != 0) {
      mode = SCREENSAVER;
    } else if (toggles[T_DC].getState() != 0) {
      mode = SCREENSAVER;
    } else if (toggles[T_ARCADE].getState() != 0) {
      mode = ARCADE;
    } else if (toggles[T_PRESETS].getState() != 0) {
      mode = PRESETS;
    } else {
      mode = SPECS;
    }
  }
  
  void sendMode() {
    port.write(SWITCHMODE);
    port.write(mode);
    if (mode == PRESETS) {
      port.write(nColorPresets);
      port.write(nModePresets);
    } else if (mode == SPECS) {
      port.write(modeOptions[mode]);
    }
  }
  
  boolean recordState() {
    if (mode == ARCADE) {
      if (port.available() > 0) {
        int inByte = port.read();
        
        // DO STUFF
        return true;
      }
    } else if (mode == PRESETS) {
      if (port.available() > 1) {
        int presetType = port.read();
        int presetSelected = port.read();
        if (presetType == COLORPRESET) selectColorPreset(presetSelected);
        else if (presetType == MODEPRESET) selectModePreset(presetSelected);
        return true;
      }
    } else if (mode == SPECS) {
      if (port.available() > 0) {
        int optionSelected = port.read();
        selectModeOption(optionSelected);
        return true;
      }
    }
    return false;
  }
}
