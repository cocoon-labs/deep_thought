public class DeepThought implements Sculpture {

  PHLightState[] lights = new PHLightState[10];
  int[] chandoIds = new int[] {0, 1, 2, 3, 4};
  int[] rimIds = new int[] {5, 6, 7, 8, 9};
  int nChandoBulbs = 1;
  int nRimBulbs = 0;
  Controller ctrl;
  ColorWheel wheel;
  boolean anyChandoChange = false;
  boolean anyRimChange = false;
  
  public DeepThought(Controller ctrl, ColorWheel wheel) {
    this.ctrl = ctrl;
    this.wheel = wheel;
    for (int i = 0; i < 10; i++) {
      lights[i] = new PHLightState();
      lights[i].setBrightness(globalBrightness);
    }
    anyChandoChange = true;
    anyRimChange = true;

    // TODO: remember to ship when the other lights/bridge are set up
    // shipChando();
    // shipRim();
  }

  public void setTopColor(float[] c) {
    anyChandoChange = true;
    for (int i = 0; i < nChandoBulbs; i++) {
      lights[chandoIds[i]].setX(c[0]);
      lights[chandoIds[i]].setY(c[1]);
    }
  }

  public void setTopBrightness(int bright) {
    anyChandoChange = true;
    for (int i = 0; i < nChandoBulbs; i++) {
      lights[chandoIds[i]].setBrightness(bright);
    }
  }

  public void setBottomColor(float[] c) {
    anyRimChange = true;
    for (int i = 0; i < nRimBulbs; i++) {
      lights[rimIds[i]].setX(c[0]);
      lights[rimIds[i]].setY(c[1]);
    }
  }

  public void setBottomBrightness(int bright) {
    anyRimChange = true;
    for (int i = 0; i < nChandoBulbs; i++) {
      lights[rimIds[i]].setBrightness(bright);
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
}
