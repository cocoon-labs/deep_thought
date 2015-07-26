public class Hyby implements Sculpture{

  PHLightState[] lights = new PHLightState[2];
  int topId, botId;
  int index;
  int nBulbs;
  Controller ctrl;
  ColorWheel wheel;
  boolean anyChange = false;

  public Hyby(int index, Controller ctrl, ColorWheel wheel, int[] bulbIds) {
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
    // ship();
  }

  public void setTopColor(float[] c) {
    anyChange = true;
    lights[0].setX(c[0]);
    lights[0].setY(c[1]);
  }
  
  public void setTopBrightness(int bright) {
    anyChange = true;
    lights[0].setBrightness(bright);
  }

  public void setBottomColor(float[] c) {
    anyChange = true;
    lights[1].setX(c[0]);
    lights[1].setY(c[1]);
  }

  public void setBottomBrightness(int bright) {
    anyChange = true;
    lights[1].setBrightness(bright);
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
    
}
