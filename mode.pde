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
    
    nBulbs = dt.totalBulbs + nHybys * 2;
    
    setDefault();
  }
  
  public void setDefault() {
    // set variables to defaults
  }
  
  public void advance() {
    if (delayCount == 0) {
      update();
      delayCount = (delayCount + 1) % delay;
    } 
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
  
  public void setByIndex(int index, int wheelPos) {
    index = constrain(index, 0, nBulbs - 1);
    if (index < 4) {
      if (index % 2 == 0) {
        hybys[index / 2].setTopColor(wheel.getHSB(wheelPos, 255));
      } else {
        hybys[index / 2].setBottomColor(wheel.getHSB(wheelPos, 255));
      }
    } else if (index < 4 + dt.totalBulbs) {
      index = index - 4;
      if (index % 2 == 0) {
        dt.setChandoColorByIndex(wheel.getHSB(0, 255), index / 2);
      } else {
        dt.setRimColorByIndex(wheel.getHSB(0, 255), index / 2);
      }
    } else {
      index -= 4 + dt.totalBulbs;
      if (index % 2 == 0) {
        hybys[2 + index / 2].setTopColor(wheel.getHSB(wheelPos, 255));
      } else {
        hybys[2 + index / 2].setBottomColor(wheel.getHSB(wheelPos, 255));
      }
    }
  }
  
  public void setTop(int index, int wheelPos) {
    index = constrain(index, 0, (nBulbs / 2) - 1);
    if (index < 2) {
      hybys[index].setTopColor(wheel.getHSB(wheelPos, 255));
    } else if (index < 2 + (dt.totalBulbs / 2)) {
      index = index - 2;
      dt.setChandoColorByIndex(wheel.getHSB(0, 255), index);
    } else {
      index -= (dt.totalBulbs / 2);
      hybys[index].setTopColor(wheel.getHSB(wheelPos, 255));
    }
  }
  
  public void setBottom(int index, int wheelPos) {
    index = constrain(index, 0, (nBulbs / 2) - 1);
    if (index < 2) {
      hybys[index].setBottomColor(wheel.getHSB(wheelPos, 255));
    } else if (index < 2 + (dt.totalBulbs / 2)) {
      index = index - 2;
      dt.setRimColorByIndex(wheel.getHSB(0, 255), index);
    } else {
      index -= (dt.totalBulbs / 2);
      hybys[index].setBottomColor(wheel.getHSB(wheelPos, 255));
    }
  }
  
  public void setTB(int index, int wheelPos) {
    setTop(index, wheelPos);
    setBottom(index, wheelPos);
  }
}
