public class HueWipe extends Mode {
  
  int speed = 5;
  int hOffset;

  public HueWipe(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
  }

  public void update() {
    for (int i = 0; i < field.maxHybys; i++) {
      hybys[i].setTopColor(wheel.getHSB(wheel.nColors * i / field.maxHybys / 4, 255));
      hybys[i].setBottomColor(wheel.getHSB(wheel.nColors / 2 + wheel.nColors * i / field.maxHybys / 4, 255));
    }
    dt.setChandoColor(wheel.getHSB(0, 255));
    dt.setRimColor(wheel.getHSB(wheel.nColors / 2, 255));
    wheel.turn(speed);
    
    if (rand.nextInt(100) == 0) {
      wheel.newScheme();
    }
  }
}
