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
  
  // Returns HUE-based color value (XY form)
  float[] getColor(int offset, int brightness) {
    return getColor(offset, brightness, scheme);
  }

  float[] getColor(int offset, int brightness, int[][] colors) {
    int schemeN = colors.length;
    int dist = 255 / schemeN;
    int[] c = new int[3];
    int position = (wheelPos + offset) % nColors;
    
    for (int i = 0; i < schemeN; i++) {
      if (position < (i + 1) * dist) {
        c = genColor(position, i, colors, dist);
        c = applyBrightness(c, brightness);
        return getRGBtoXY(c);
      }
    }
    c = genColor(position, schemeN - 1, colors, dist);
    c = applyBrightness(c, brightness);
    return getRGBtoXY(c);
  }

  private int[] genColor(int position, int idx, int[][] colors, int dist) {
    position = position - (idx * dist);
    int schemeN = colors.length;
    int[] result = new int[3];
    for (int i = 0; i < 3; i++) {
      result[i] = 
        colors[idx][i] + 
          (position * 
            (colors[(idx+1) % schemeN][i] - colors[idx][i]) / 
            dist);
    }
    return result;
  }

  public int[] applyBrightness(int[] c, int brightness) {
    int[] newC = new int[3];
    newC[0] = int(map(brightness, 0, 255, 0, c[0]));
    newC[1] = int(map(brightness, 0, 255, 0, c[1]));
    newC[2] = int(map(brightness, 0, 255, 0, c[2]));
    return newC;
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

  private float[] getRGBtoXY(int[] c) {
    // For the hue bulb the corners of the triangle are:
    // -Red: 0.675, 0.322
    // -Green: 0.4091, 0.518
    // -Blue: 0.167, 0.04
    float[] normalizedToOne = new float[3];
    float cred, cgreen, cblue;
    cred = (float) c[0];
    cgreen = (float) c[1];
    cblue = (float) c[2];
    normalizedToOne[0] = (cred / 255);
    normalizedToOne[1] = (cgreen / 255);
    normalizedToOne[2] = (cblue / 255);
    float red, green, blue;

    // Make red more vivid
    if (normalizedToOne[0] > 0.04045) {
      red = (float) Math.pow((normalizedToOne[0] + 0.055) / (1.0 + 0.055), 2.4);
                             
    } else {
      red = (float) (normalizedToOne[0] / 12.92);
    }

    // Make green more vivid
    if (normalizedToOne[1] > 0.04045) {
      green = (float) Math.pow((normalizedToOne[1] + 0.055)
                               / (1.0 + 0.055), 2.4);
    } else {
      green = (float) (normalizedToOne[1] / 12.92);
    }

    // Make blue more vivid
    if (normalizedToOne[2] > 0.04045) {
      blue = (float) Math.pow((normalizedToOne[2] + 0.055)
                              / (1.0 + 0.055), 2.4);
    } else {
      blue = (float) (normalizedToOne[2] / 12.92);
    }

    float X = (float) (red * 0.649926 + green * 0.103455 + blue * 0.197109);
    float Y = (float) (red * 0.234327 + green * 0.743075 + blue * 0.022598);
    float Z = (float) (red * 0.0000000 + green * 0.053077 + blue * 1.035763);

    float x = X / (X + Y + Z);
    float y = Y / (X + Y + Z);

    float[] xy = new float[2];
    xy[0] = x;
    xy[1] = y;
    return xy;
  }
}
