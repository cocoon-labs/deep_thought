class DeepThought {

  PHLightState[] lights = new PHLightState[10];
  int[] chandoIds = new int[] {0, 1, 2, 3, 4};
  int[] rimIds = new int[] {5, 6, 7, 8, 9};
  int[][][] lightsXY = new int[2][5][2]; // [top/bottom][index][x/y]
  float[][][] colors = new float[2][5][3]; // [top/bottom][index][h/s/b]
  int nChandoBulbs = 1;
  int maxChandoBulbs = 5;
  int nRimBulbs = 0;
  int maxRimBulbs = 5;
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

  public void setChandoColor(float[] c) {
    anyChandoChange = true;
    for (int i = 0; i < maxChandoBulbs; i++) {
//      lights[chandoIds[i]].setX(c[0]);
//      lights[chandoIds[i]].setY(c[1]);
      lights[chandoIds[i]].setHue((int) map(c[0], 0, 1, 0, 65280));
      lights[chandoIds[i]].setSaturation((int) map(c[1], 0, 1, 0, 254));
      lights[chandoIds[i]].setBrightness((int) map(c[2], 0, 1, 1, 254));
      colors[0][i] = c;
    }
  }

  public void setRimColor(float[] c) {
    anyRimChange = true;
    for (int i = 0; i < maxRimBulbs; i++) {
//      lights[rimIds[i]].setX(c[0]);
//      lights[rimIds[i]].setY(c[1]);
      lights[rimIds[i]].setHue((int) map(c[0], 0, 1, 0, 65280));
      lights[rimIds[i]].setSaturation((int) map(c[1], 0, 1, 0, 254));
      lights[rimIds[i]].setBrightness((int) map(c[2], 0, 1, 1, 254));
      colors[1][i] = c;
    }
  }

  public void setChandoColorByIndex(float[] c, int idx) {
    anyChandoChange = true;
    lights[chandoIds[idx]].setX(c[0]);
    lights[chandoIds[idx]].setY(c[1]);
  }

  public void setRimColorByIndex(float[] c, int idx) {
    anyRimChange = true;
    lights[rimIds[idx]].setX(c[0]);
    lights[rimIds[idx]].setY(c[1]);
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
}
