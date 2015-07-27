public class GradientWipe extends Mode {
  
  int speed = 10;

  public GradientWipe(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
  }

  public void update() {
    for (int i = 0; i < nHybys; i++) {
      hybys[i].setTopColor(wheel.getColor(0, 255));
      hybys[i].setBottomColor(wheel.getColor(wheel.nColors/2, 255));
    }
    dt.setChandoColor(wheel.getColor(0, 255));
    wheel.turn(speed);
  }
}
