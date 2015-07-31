public class DeepThought implements Sculpture {

  PHLightState[] lights = new PHLightState[10];
  int[] chandoIds = new int[] {0, 1, 2, 3, 4};
  int[] rimIds = new int[] {5, 6, 7, 8, 9};
  int[][][] lightsXY = new int[2][5][2]; // [top/bottom][index][x/y]
  float[][][] colors = new float[2][5][3]; // [top/bottom][index][h/s/b]
  int nChandoBulbs = 1;
  int maxChandoBulbs = 5;
  int nRimBulbs = 0;
  int maxRimBulbs = 5;
  int totalBulbs = maxChandoBulbs + maxRimBulbs;
  Controller ctrl;
  ColorWheel wheel;
  boolean anyChandoChange = false;
  boolean anyRimChange = false;
  int lightSize = 15;
  
  public DeepThought(Controller ctrl, ColorWheel wheel, int[][][] lightsXY) {
    this.ctrl = ctrl;
    this.wheel = wheel;
    for (int i = 0; i < 10; i++) {
      lights[i] = new PHLightState();
      lights[i].setBrightness(globalBrightness);
    }
    anyChandoChange = true;
    anyRimChange = true;
    
    this.lightsXY = lightsXY;

    // TODO: remember to ship when the other lights/bridge are set up
    // shipChando();
    // shipRim();
  }

  public void setTopColor(float[] c) {
    anyChandoChange = true;
    for (int i = 0; i < maxChandoBulbs; i++) {
      lights[chandoIds[i]].setHue((int) map(c[0], 0, 1, 0, 65280));
      lights[chandoIds[i]].setSaturation((int) map(c[1], 0, 1, 0, 254));
      lights[chandoIds[i]].setBrightness((int) map(c[2], 0, 1, 1, 254));
      colors[0][i] = c;
    }
  }
  
  public void setTopColor(int wheelPos, int wheelStep) {
    anyChandoChange = true;
    for (int i = 0; i < maxChandoBulbs; i++) {
      float[] c = wheel.getHSB(wheelPos + i * wheelStep, 255);
      lights[chandoIds[i]].setHue((int) map(c[0], 0, 1, 0, 65280));
      lights[chandoIds[i]].setSaturation((int) map(c[1], 0, 1, 0, 254));
      lights[chandoIds[i]].setBrightness((int) map(c[2], 0, 1, 1, 254));
      colors[0][i] = c;
    }
  }
  
  public void setZZColor(int wheelPos, int neighborStep, int topBottomStep) {
    anyChandoChange = true;
    anyRimChange = true;
    for (int i = 0; i < maxChandoBulbs; i++) {
      float[] c;
      if (i % 2 == 0) {
        c = wheel.getHSB(wheelPos + i * neighborStep, 255);
      } else {
        c = wheel.getHSB(wheelPos + topBottomStep + i * neighborStep, 255);
      }
      lights[chandoIds[i]].setHue((int) map(c[0], 0, 1, 0, 65280));
      lights[chandoIds[i]].setSaturation((int) map(c[1], 0, 1, 0, 254));
      lights[chandoIds[i]].setBrightness((int) map(c[2], 0, 1, 1, 254));
      colors[0][i] = c;
    }
    for (int i = 0; i < maxRimBulbs; i++) {
      float[] c;
      if (i % 2 != 0) {
        c = wheel.getHSB(wheelPos + i * neighborStep, 255);
      } else {
        c = wheel.getHSB(wheelPos + topBottomStep + i * neighborStep, 255);
      }
      lights[rimIds[i]].setHue((int) map(c[0], 0, 1, 0, 65280));
      lights[rimIds[i]].setSaturation((int) map(c[1], 0, 1, 0, 254));
      lights[rimIds[i]].setBrightness((int) map(c[2], 0, 1, 1, 254));
      colors[1][i] = c;
    }
  }

  public void setTopBrightness(int bright) {
    anyChandoChange = true;
    bright = constrain(bright, 1, 254);
    for (int i = 0; i < nChandoBulbs; i++) {
      lights[chandoIds[i]].setBrightness(bright);
      colors[0][i][2] = bright;
    }
  }

  public void setBottomColor(float[] c) {
    anyRimChange = true;
    for (int i = 0; i < maxRimBulbs; i++) {
      lights[rimIds[i]].setHue((int) map(c[0], 0, 1, 0, 65280));
      lights[rimIds[i]].setSaturation((int) map(c[1], 0, 1, 0, 254));
      lights[rimIds[i]].setBrightness((int) map(c[2], 0, 1, 1, 254));
      colors[1][i] = c;
    }
  }
  
  public void setBottomColor(int wheelPos, int wheelStep) {
    anyRimChange = true;
    for (int i = 0; i < maxRimBulbs; i++) {
      float[] c = wheel.getHSB(wheelPos + i * wheelStep, 255);
      lights[rimIds[i]].setHue((int) map(c[0], 0, 1, 0, 65280));
      lights[rimIds[i]].setSaturation((int) map(c[1], 0, 1, 0, 254));
      lights[rimIds[i]].setBrightness((int) map(c[2], 0, 1, 1, 254));
      colors[1][i] = c;
    }
  }

  public void setBottomBrightness(int bright) {
    anyRimChange = true;
    bright = constrain(bright, 1, 254);
    for (int i = 0; i < nChandoBulbs; i++) {
      lights[rimIds[i]].setBrightness(bright);
      colors[1][i][2] = bright;
    }
  }

  public void setChandoColorByIndex(float[] c, int idx) {
    anyChandoChange = true;
    lights[chandoIds[idx]].setHue((int) map(c[0], 0, 1, 0, 65280));
    lights[chandoIds[idx]].setSaturation((int) map(c[1], 0, 1, 0, 254));
    lights[chandoIds[idx]].setBrightness((int) map(c[2], 0, 1, 1, 254));
    colors[0][idx] = c;
  }

  public void setRimColorByIndex(float[] c, int idx) {
    anyRimChange = true;
    lights[rimIds[idx]].setHue((int) map(c[0], 0, 1, 0, 65280));
    lights[rimIds[idx]].setSaturation((int) map(c[1], 0, 1, 0, 254));
    lights[rimIds[idx]].setBrightness((int) map(c[2], 0, 1, 1, 254));
    colors[1][idx] = c;
  }

  public void ship() {
    shipChando();
    shipRim();
  }

  public void shipChando() {
    if (anyChandoChange) {
      for (int i = 0; i < nChandoBulbs; i++) {
        ctrl.updateLight(1, chandoIds[i], lights[chandoIds[i]]);
        lights[chandoIds[i]] = new PHLightState();
      }
    }
    anyChandoChange = false;
  }

  public void shipRim() {
    if (anyRimChange) {
      for (int i = 0; i < nRimBulbs; i++) {
        ctrl.updateLight(1, rimIds[i], lights[rimIds[i]]);
        lights[rimIds[i]] = new PHLightState();
      }
    }
    anyRimChange = false;
  }
  
  public void draw() {
    for (int i = 0; i < maxChandoBulbs; i++) {
      int rgb = Color.HSBtoRGB(colors[0][i][0], colors[0][i][1], colors[0][i][2]);
      int r = (rgb >> 16) & 0xFF;
      int g = (rgb >> 8) & 0xFF;
      int b = rgb & 0xFF;
      fill(r, g, b);
      ellipse(lightsXY[0][i][0], lightsXY[0][i][1] - bgOffset, lightSize, lightSize);
    }
    for (int i = 0; i < maxRimBulbs; i++) {
      int rgb = Color.HSBtoRGB(colors[1][i][0], colors[1][i][1], colors[1][i][2]);
      int r = (rgb >> 16) & 0xFF;
      int g = (rgb >> 8) & 0xFF;
      int b = rgb & 0xFF;
      fill(r, g, b);
      ellipse(lightsXY[1][i][0], lightsXY[1][i][1] - bgOffset, lightSize, lightSize);
    }
  }
  
  void rotateChando(boolean dir) {
    anyChandoChange = true;
    if (dir) {
      float[] firstC = new float[] {colors[0][0][0], colors[0][0][1], colors[0][0][2]};
      for (int i = 0; i < maxRimBulbs - 1; i++) {
        float[] c = new float[] {colors[0][i+1][0], colors[0][i+1][1], colors[0][i+1][2]};
        setChandoColorByIndex(c, i);
      }
      setChandoColorByIndex(firstC, maxRimBulbs - 1);
    } else {
      float[] lastC = new float[] {colors[0][maxRimBulbs - 1][0], colors[0][maxRimBulbs - 1][1], colors[0][maxRimBulbs - 1][2]};
      for (int i = maxRimBulbs - 1; i > 0; i--) {
        float[] c = new float[] {colors[0][i-1][0], colors[0][i-1][1], colors[0][i-1][2]};
        setChandoColorByIndex(c, i);
      }
      setChandoColorByIndex(lastC, 0);
    }
  }
  
  void rotateRim(boolean dir) {
    anyRimChange = true;
    if (dir) {
      float[] firstC = new float[] {colors[1][0][0], colors[1][0][1], colors[1][0][2]};
      for (int i = 0; i < maxRimBulbs - 1; i++) {
        float[] c = new float[] {colors[1][i+1][0], colors[1][i+1][1], colors[1][i+1][2]};
        setRimColorByIndex(c, i);
      }
      setRimColorByIndex(firstC, maxRimBulbs - 1);
    } else {
      float[] lastC = new float[] {colors[1][maxRimBulbs - 1][0], colors[1][maxRimBulbs - 1][1], colors[1][maxRimBulbs - 1][2]};
      for (int i = maxRimBulbs - 1; i > 0; i--) {
        float[] c = new float[] {colors[1][i-1][0], colors[1][i-1][1], colors[1][i-1][2]};
        setRimColorByIndex(c, i);
      }
      setRimColorByIndex(lastC, 0);
    }
  }
}
