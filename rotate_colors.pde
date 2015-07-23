public class RotateColors extends Mode {

  public RotateColors(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
  }

  public void update() {
    for (int i = 0; i < nHybys; i++) {
      hybys[i].setTopColor(wheel.getColor(0, 255));
      hybys[i].setBottomColor(wheel.getColor(128, 255));
    }
    wheel.turn(16);
  }
}
