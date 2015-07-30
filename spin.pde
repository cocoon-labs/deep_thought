public class Spin extends Mode {
  
  // variables to link
  int loopStep;
  boolean chandoDir, rimDir, topDir, botDir;
  int chanceDir;
  int chanceSeed;

  public Spin(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
  }

  public void update() {
    super.update();
    seedNew();
    rotateHybysTop(topDir);
    rotateHybysBot(botDir);
    dt.rotateChando(chandoDir);
    dt.rotateRim(rimDir);
    wheel.turn(loopStep);
  }
  
  public void setDefault() {
    loopStep = ceil(wheel.nColors / 300);
    chandoDir = true;
    rimDir = true;
    topDir = true;
    botDir = true;
    chanceDir = 50;
    chanceSeed = 8;
  }
  
  public void randomize() {
    if (rand.nextInt(chanceDir) == 0) {
      chandoDir = !chandoDir;
    }
    if (rand.nextInt(chanceDir) == 0) {
      rimDir = !rimDir;
    }
    if (rand.nextInt(chanceDir) == 0) {
      topDir = !topDir;
    }
    if (rand.nextInt(chanceDir) == 0) {
      botDir = !botDir;
    }
  }
  
  public void seedNew() {
    if (rand.nextInt(chanceSeed) == 0) {
      dt.setChandoColorByIndex(wheel.getHSB(0, 255), rand.nextInt(dt.maxChandoBulbs));
    }
    if (rand.nextInt(chanceSeed) == 0) {
      dt.setRimColorByIndex(wheel.getHSB(0, 255), rand.nextInt(dt.maxRimBulbs));
    }
    if (rand.nextInt(chanceSeed) == 0) {
      hybys[rand.nextInt(nHybys)].setTopColor(wheel.getHSB(0, 255));
    }
    if (rand.nextInt(chanceSeed) == 0) {
      hybys[rand.nextInt(nHybys)].setBottomColor(wheel.getHSB(0, 255));
    }
  }
  
}
