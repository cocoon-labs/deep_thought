public class HueWipe extends Mode {
  
  // variables to link
  int hybyStep;
  int topBottomStep;
  int loopStep;
  int dtStep;

  public HueWipe(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
  }

  public void update() {
    super.update();
    for (int i = 0; i < field.maxHybys; i++) {
      hybys[i].setTopColor(wheel.getHSB(i * hybyStep, 255));
      hybys[i].setBottomColor(wheel.getHSB(topBottomStep + i * hybyStep, 255));
    }
    dt.setTopColor(0, dtStep);
    dt.setBottomColor(topBottomStep, dtStep);
    wheel.turn(loopStep);
  }
  
  public void setDefault() {
    hybyStep = ceil(wheel.nColors / 16);
    topBottomStep = ceil(wheel.nColors / 2);
    loopStep = ceil(wheel.nColors / 300);
    dtStep = ceil(wheel.nColors / 20);
  }
}
