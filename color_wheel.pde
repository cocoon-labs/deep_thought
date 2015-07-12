class ColorWheel {
  
  int wheelPos = 0;
  int nColors = 256;
  
  // THIS WILL PROBABLY TOTALLY CHANGE
  // NOT EVEN SURE HOW COLOR WHEEL WILL BE REPRESENTED
  // BY HUE NUMBER? SOME OTHER WAY? WE SHALL SEE
  // BUT SOME KIND OF ARRAY LIKE THIS EXISTS
  int[][][] presets = {
    { {255, 0, 0}, {0, 255, 0}, {0, 0, 255} }, //rainblow
    { {255, 0, 0}, {177, 67, 226}, {0, 0, 255} }, // red purple blue
    { {218, 107, 44}, {240, 23, 0}, {147, 0, 131} }, // snowskirt
    { {0, 0, 0}, {128, 0, 255}, {128, 0, 128} }, // royal
    { {122, 0, 255}, {0, 0, 255}, {0, 88, 205} }, // cool
    { {0, 0, 0}, {196, 0, 255}, {209, 209, 209} }, // dork
    { {177, 0, 177}, {77, 17, 71}, {247, 77, 7} }, // sevens
    { {128, 0, 255}, {0, 0, 0}, {255, 128, 0} }, // orpal
    { {255, 0, 0}, {0, 255, 0}, {0, 0, 255} } // rainbow
  };
  
  // AGAIN, PROBABLY WON'T BE RGB BUT CURRENT SCHEME[] EXISTS IN SOME FASHION
  int[][] scheme = { {255, 0, 0}, {0, 255, 0}, {0, 0, 255} };
  
  ColorWheel() {
    newScheme();
  }
  
  // DOES NOT HAVE TO BE MODULO 256!
  // nColors DEPENDS ON HOW WHEEL IS DEFINED
  void turn(int step) {
    wheelPos = (wheelPos + step) % nColors;
  }
  
  // Returns HUE-based color value
  int getColor(int offset) {
    return 0;
  }
  
  void newScheme() {
    // GENERATE NEW SCHEME SOMEHOW
  }
  
  void setPreset(int preset) {
    /* SOMETHING LIKE THIS
    scheme[0] = presets[preset][0];
    scheme[1] = presets[preset][1];
    scheme[2] = presets[preset][2];
    */
  }
  
}
