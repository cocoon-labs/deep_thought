class ColorWheel {
  
  int wheelPos = 0;
  int nColors = 1500;
  int vibe = 0;
  int minBrightness = 10;
  
  int[][][] presets = {
    { {255, 0, 0}, {0, 255, 0}, {0, 0, 255} }, //rainblow
    { {255, 0, 0}, {177, 67, 226}, {0, 0, 255} }, // red purple blue
    { {218, 107, 44}, {240, 23, 0}, {147, 0, 131} }, // snowskirt
    { {0, 0, 255}, {128, 0, 255}, {128, 0, 128} }, // royal
    { {122, 0, 255}, {0, 0, 255}, {0, 88, 205} }, // cool
    { {255, 0, 196}, {196, 0, 255}, {209, 209, 209} }, // dork
    { {177, 0, 177}, {77, 17, 71}, {247, 77, 7} }, // sevens
    { {128, 0, 255}, {255, 0, 128}, {255, 128, 0} }, // orpal
    { {255, 200, 200}, {255, 255, 255}, {200, 200, 255} }, // pink white - white - blue white
    { {200, 200, 255}, {255, 0, 255}, {255, 200, 200} }, // blue white - purple - pink white
    { {255, 128, 0}, {0, 0, 255}, {255, 230, 255} }, // orange - blue - white
    { {255, 0, 0}, {255, 128, 0}, {128, 255, 0}, {0, 255, 0}, {0, 255, 128}, {0, 128, 255}, {0, 0, 255}, {128, 0, 255}, {255, 0, 128} } // rainbow detail
  };
  
  int[][] scheme = { {255, 0, 0}, {0, 255, 0}, {0, 0, 255} };
  
  ColorWheel() {
    newScheme();
  }
  
  void turn(int step) {
    wheelPos = (wheelPos + step) % nColors;
  }
  
  // Returns HUE-based color value (XY form)
//  float[] getColor(int offset, int brightness) {
//    return getColor(offset, brightness, scheme);
//  }
//
//  float[] getColor(int offset, int brightness, int[][] colors) {
//    int schemeN = colors.length;
//    int dist = nColors / schemeN;
//    int[] c = new int[3];
//    int position = (wheelPos + offset) % nColors;
//    
//    for (int i = 0; i < schemeN; i++) {
//      if (position < (i + 1) * dist) {
//        c = genColor(position, i, colors, dist);
//        c = applyBrightness(c, brightness);
//        return getRGBtoXY(c);
//      }
//    }
//    c = genColor(position, schemeN - 1, colors, dist);
//    c = applyBrightness(c, brightness);
//    return getRGBtoXY(c);
//  }

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
    switch(vibe) {
      case(0) : // DEFAULT
        genScheme(128);
        // genScheme(280, 420); this is warm
        // genScheme(62, 284); this is cool
        break;
      case(1) : // WHITE
        genSchemeWhite();
        break;
    }
  }
  
  void setPreset(int preset) {
    preset = preset % presets.length;
    int schemeLength = presets[preset].length;
    scheme = new int[schemeLength][3];
    for (int i = 0; i < schemeLength; i++) {
      scheme[i] = presets[preset][i];
    }
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
  
  // Returns HSB-based color value
  float[] getHSB(int offset, int brightness) {
    int[] rgb = getRGBColor(offset, brightness);
    float[] hsb = Color.RGBtoHSB(rgb[0], rgb[1], rgb[2], null);
    hsb[2] = map(hsb[2], 0, 255, 0, brightness);
    return hsb;
  }
  
  int[] getRGBColor(int offset, int brightness) {
    return getRGBColor(offset, brightness, scheme);
  }

  int[] getRGBColor(int offset, int brightness, int[][] colors) {
    int schemeN = colors.length;
    int dist = nColors / schemeN;
    int[] c = new int[3];
    int position = (wheelPos + offset) % nColors;
    
    for (int i = 0; i < schemeN; i++) {
      if (position < (i + 1) * dist) {
        c = genColor(position, i, colors, dist);
        c = applyBrightness(c, brightness);
        return c;
      }
    }
    c = genColor(position, schemeN - 1, colors, dist);
    c = applyBrightness(c, brightness);
    return c;
  }
  
  public void genScheme(int colorThreshold) {
    int[] newColor = getRGBColor(0, 255);
    scheme = new int[3][3];
    scheme[0] = newColor;
    while (euclideanDistance(scheme[0], newColor) < colorThreshold) {
      newColor = randColor();
    }
    scheme[1] = newColor;
      
    while (euclideanDistance(scheme[0], newColor) < colorThreshold ||
           euclideanDistance(scheme[1], newColor) < colorThreshold) {
      newColor = randColor();
    }
    scheme[2] = newColor;
    wheelPos = 0;
  }
  
  public void genScheme(int minHue, int maxHue) {
    minHue = (minHue + 360) % 360;
    maxHue = maxHue % 360;
    scheme[0] = randColor(minHue, maxHue);
    scheme[1] = randColor(minHue, maxHue);
    scheme[2] = randColor(minHue, maxHue);
    
    wheelPos = 0;
  }
  
  public void genSchemeWhite() {
    scheme[0] = new int[] {255, 255, 255};
    scheme[1] = new int[] {255, 255, 255};
    scheme[2] = new int[] {255, 255, 255};
  }
  
  private int[] randColor() {
    int[] c = new int[] { rand.nextInt(256), rand.nextInt(256), rand.nextInt(256) };
    if (brightness(color(c[0], c[1], c[2])) < minBrightness)
      return randColor();
    else
      return c;
  }
  
  private int[] randColor(int minHue, int maxHue) {
    minHue = (minHue + 360) % 360;
    maxHue = maxHue % 360;
    int[] c = new int[] { rand.nextInt(256), rand.nextInt(256), rand.nextInt(256) };
    int hue = getHue(c);
    if (minHue > maxHue) {
      while(hue > maxHue && hue < minHue) {
        c = new int[] { rand.nextInt(256), rand.nextInt(256), rand.nextInt(256) };
        hue = getHue(c);
      }
    } else {
      while(hue < minHue || hue > maxHue) {
        c = new int[] { rand.nextInt(256), rand.nextInt(256), rand.nextInt(256) };
        hue = getHue(c);
      }
    }
    return c;
  }
  
  private int getHue(int[] c) {
    float[] hsb = Color.RGBtoHSB(c[0], c[1], c[2], null);
    return (int) (360 * hsb[0]);
  }
  
  private double euclideanDistance(int[] c1, int[] c2) {
    double sumOfCubes = 
      Math.pow(Math.abs(c2[0] - c1[0]), 3) +
      Math.pow(Math.abs(c2[1] - c1[1]), 3) +
      Math.pow(Math.abs(c2[2] - c1[2]), 3);
    return  Math.pow(sumOfCubes, 1.0/3);
  }
}
