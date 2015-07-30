public class Sweep extends Mode {
  
  // variables to link
  int loopStep;
  int syncStyle; // 0: top&bottom synced; 1: top&bottom in separate waves; 2: traverse by total index;
  
  int phase;
  int pos;

  public Sweep(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
  }

  public void update() {
    super.update();
    updatePhase(phase);
  }
  
  public void setDefault() {
    loopStep = 10;
    syncStyle = 0;
    phase = 0;
    pos = 0;
  }
  
  void updatePhase(int ph) {
    if (syncStyle == 0) {
      switch(ph % 2) {
        case 0: // moving 0 to end
          setTB(pos, 0);
          pos++;
          if (pos >= nBulbs / 2) {
            pos = nBulbs/2 - 1;
            phase = 1;
            wheel.turn(loopStep);
          }
          break;
        case 1: // moving end to 0
          setTB(pos, 0);
          pos--;
          if (pos <= 0) {
            pos = 0;
            phase = 0;
            wheel.turn(loopStep);
          }
          break;
      }
    } else if (syncStyle == 1) {
      switch(ph) {
        case 0: // moving across top from 0 to end
          setTop(pos, 0);
          pos++;
          if (pos >= nBulbs / 2) {
            pos = 0;
            phase = 1;
            wheel.turn(loopStep);
          }
          break;
        case 1: // moving across bottom from 0 to end
          setBottom(pos, 0);
          pos++;
          if (pos >= nBulbs / 2) {
            pos = nBulbs/2 - 1;
            phase = 2;
            wheel.turn(loopStep);
          }
          break;
        case 2: // moving across top from end to 0
          setTop(pos, 0);
          pos--;
          if (pos <= 0) {
            pos = nBulbs/2 - 1;
            phase = 3;
            wheel.turn(loopStep);
          }
          break;
        case 3: // moving across bottom from end to 0
          setBottom(pos, 0);
          pos--;
          if (pos <= 0) {
            pos = 0;
            phase = 0;
            wheel.turn(loopStep);
          }
          break;
      }
    } else {
      switch(ph % 2) {
        case 0: // moving 0 to end
          setByIndex(pos, 0);
          pos++;
          if (pos >= nBulbs) {
            pos = nBulbs - 1;
            phase = 1;
            wheel.turn(loopStep);
          }
          break;
        case 1: // moving end to 0
          setByIndex(pos, 0);
          pos--;
          if (pos <= 0) {
            pos = 0;
            phase = 0;
            wheel.turn(loopStep);
          }
          break;
      }
    }
  }
}
