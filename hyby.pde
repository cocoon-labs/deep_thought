public class Hyby {

  PHLightState[] lights = new PHLightState[2];
  int topIdx, botIdx;
  int index;
  int nBulbs;
  Controller ctrl;
  ColorWheel wheel;
  boolean anyChange = false;

  public Hyby(int index, Controller ctrl, ColorWheel wheel, int topIdx, int botIdx) {
    this.index = index;
    this.ctrl = ctrl;
    this.wheel = wheel;
    this.topIdx = topIdx;
    this.botIdx = botIdx;
    nBulbs = lights.length;
    for (int i = 0; i < nBulbs; i++) {
      lights[i] = new PHLightState();
      lights[i].setBrightness(globalBrightness);
    }
    anyChange = true;
    ship();
    
  }

  public void setTopColor(float[] c) {
    anyChange = true;
    lights[0].setX(c[0]);
    lights[0].setY(c[1]);
  }

  public void setBottomColor(float[] c) {
    anyChange = true;
    lights[1].setX(c[0]);
    lights[1].setY(c[1]);
  }

  public void ship() {
    if (anyChange) {
      ctrl.updateLight(topIdx, lights[0]);
      ctrl.updateLight(botIdx, lights[1]);
      for (int i = 0; i < nBulbs; i++) {
        lights[i] = new PHLightState();
      }
    }
    anyChange = false;
  } 
    
}
