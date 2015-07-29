public class Mode {
  
  // variables and stuff
  Hyby[] hybys;
  DeepThought dt;
  ColorWheel wheel;
  float fadeFactor;
  int chance;
  int nHybys, nBulbs;
  
  public Mode(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    this.hybys = hybys;
    this.dt = dt;
    this.wheel = wheel;
    this.fadeFactor = fadeFactor;
    this.chance = chance;
    this.nHybys = hybys.length;
    
    //TODO: update this to include deep thought lights
    nBulbs = hybys.length * 2;
    
    setDefault();
  }
  
  public void setDefault() {
    // set variables to defaults
  }
  
  public void advance() {
    update();
  }

  public void update() {
    randomize();
  }
  
  public void randomize() {
    
  }
  
  public void rotateHybysTop(boolean dir) {
    if (dir) {
      float[] firstC = new float[] {hybys[0].colors[0][0], hybys[0].colors[0][1], hybys[0].colors[0][2]};
      for (int i = 0; i < nHybys - 1; i++) {
        float[] c = hybys[i+1].colors[0];
        hybys[i].setTopColor(c);
      }
      hybys[nHybys - 1].setTopColor(firstC);
    } else {
      float[] lastC = new float[] {hybys[nHybys - 1].colors[0][0], hybys[nHybys - 1].colors[0][1], hybys[nHybys - 1].colors[0][2]};
      for (int i = nHybys - 1; i > 0; i--) {
        float[] c = new float[] {hybys[i-1].colors[0][0], hybys[i-1].colors[0][1], hybys[i-1].colors[0][2]};
        hybys[i].setTopColor(c);
      }
      hybys[0].setTopColor(lastC);
    }
  }
  
  public void rotateHybysBot(boolean dir) {
    if (dir) {
      float[] firstC = new float[] {hybys[0].colors[1][0], hybys[0].colors[1][1], hybys[0].colors[1][2]};
      for (int i = 0; i < nHybys - 1; i++) {
        float[] c = hybys[i+1].colors[1];
        hybys[i].setBottomColor(c);
      }
      hybys[nHybys - 1].setBottomColor(firstC);
    } else {
      float[] lastC = new float[] {hybys[nHybys - 1].colors[1][0], hybys[nHybys - 1].colors[1][1], hybys[nHybys - 1].colors[1][2]};
      for (int i = nHybys - 1; i > 0; i--) {
        float[] c = new float[] {hybys[i-1].colors[1][0], hybys[i-1].colors[1][1], hybys[i-1].colors[1][2]};
        hybys[i].setBottomColor(c);
      }
      hybys[0].setBottomColor(lastC);
    }
  }
  
}
