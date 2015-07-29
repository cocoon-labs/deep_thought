public class ZigZagWipe extends Mode {
  
  // variables to link
  int hybyStep;
  int topBottomStep;
  int loopStep;
  int dtStep;

  public ZigZagWipe(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
  }

  public void update() {
    super.update();
    for (int i = 0; i < field.maxHybys; i++) {
      if (i % 2 == 0) {
        hybys[i].setTopColor(wheel.getHSB(i * hybyStep, 255));
        hybys[i].setBottomColor(wheel.getHSB(topBottomStep + i * hybyStep, 255));
      } else {
        hybys[i].setBottomColor(wheel.getHSB(i * hybyStep, 255));
        hybys[i].setTopColor(wheel.getHSB(topBottomStep + i * hybyStep, 255));
      }
    }
    dt.setZZColor(0, dtStep, topBottomStep);
    wheel.turn(loopStep);
  }
  
  public void setDefault() {
    hybyStep = wheel.nColors / 16;
    topBottomStep = wheel.nColors / 2;
    loopStep = wheel.nColors / 300;
    dtStep = wheel.nColors / 20;
  }
}
