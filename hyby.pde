public class Hyby {

  PHLightState[] lights = new PHLightState[2];
  int[][] tbXY = new int[2][2]; // [top/bottom][x/y]
  float[][] colors = new float[2][3]; // [top/bottom][h/s/b]
  int topId, botId;
  int index;
  int nBulbs;
  Controller ctrl;
  ColorWheel wheel;
  boolean anyChange = false;
  int lightSize = 30;

  public Hyby(int index, Controller ctrl, ColorWheel wheel, int[] bulbIds, int[][] tbXY) {
    this.index = index;
    this.ctrl = ctrl;
    this.wheel = wheel;
    this.topId = bulbIds[0];
    this.botId = bulbIds[1];
    nBulbs = lights.length;
    for (int i = 0; i < nBulbs; i++) {
      lights[i] = new PHLightState();
      lights[i].setBrightness(globalBrightness);
    }
    anyChange = true;
    this.tbXY = tbXY;
    // ship();
  }

  public void setTopColor(float[] c) {
//    anyChange = true;
//    lights[0].setX(c[0]);
//    lights[0].setY(c[1]);
    anyChange = true;
    lights[0].setHue((int) map(c[0], 0, 1, 0, 65280));
    lights[0].setSaturation((int) map(c[1], 0, 1, 0, 254));
    lights[0].setBrightness((int) map(c[2], 0, 1, 1, 254));
    colors[0] = c;
  }

  public void setBottomColor(float[] c) {
//    anyChange = true;
//    lights[1].setX(c[0]);
//    lights[1].setY(c[1]);
    anyChange = true;
    lights[1].setHue((int) map(c[0], 0, 1, 0, 65280));
    lights[1].setSaturation((int) map(c[1], 0, 1, 0, 254));
    lights[1].setBrightness((int) map(c[2], 0, 1, 1, 254));
    colors[1] = c;
  }

  public void ship() {
    if (anyChange) {
      ctrl.updateLight(0, topId, lights[0]);
      ctrl.updateLight(0, botId, lights[1]);
      for (int i = 0; i < nBulbs; i++) {
        lights[i] = new PHLightState();
      }
    }
    anyChange = false;
  }
  
  public void draw(int index) {
    for (int tb = 0; tb < 2; tb++) {
      int rgb = Color.HSBtoRGB(colors[tb][0], colors[tb][1], colors[tb][2]);
      int r = (rgb >> 16) & 0xFF;
      int g = (rgb >> 8) & 0xFF;
      int b = rgb & 0xFF;
      fill(r, g, b);
      ellipse(tbXY[tb][0], tbXY[tb][1] - bgOffset, lightSize, lightSize);
    }
  }
    
}
