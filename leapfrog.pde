public class Leapfrog extends Mode {
  
  // variables to link
  int distance;
  int nSteps; // steps it takes to traverse distance
  int loopStep;
  
  int phase;
  int phaseCount;

  public Leapfrog(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
    phase = 0;
    phaseCount = 0;
  }

  public void update() {
    super.update();
    updatePhase(phase);
  }
  
  public void setDefault() {
    distance = wheel.nColors / 2;
    nSteps = 10;
    loopStep = 1;
  }
  
  void updatePhase(int p) {
    int distStep = distance / nSteps;
    switch(p) {
      case 0: // moving bottom from 0 to distance
        setBottomByPhaseCount();
        phaseCount += distStep;
        if (phaseCount >= distance) {
          phaseCount = 0;
          phase = 1;
          wheel.turn(loopStep);
        }
        break;
      case 1: // moving top from 0 to distance
        setTopByPhaseCount();
        phaseCount += distStep;
        if (phaseCount >= distance) {
          phaseCount = distance;
          phase = 2;
          wheel.turn(loopStep);
        }
        break;
      case 2: // moving bottom from distance to 0
        setBottomByPhaseCount();
        phaseCount -= distStep;
        if (phaseCount <= 0) {
          phaseCount = distance;
          phase = 3;
          wheel.turn(loopStep);
        }
        break;
      case 3: // moving top from distance to 0
        setTopByPhaseCount();
        phaseCount -= distStep;
        if (phaseCount <= 0) {
          phaseCount = 0;
          phase = 0;
          wheel.turn(loopStep);
        }
        break;
    }
  }
  
  void setBottomByPhaseCount() {
    for (int i = 0; i < field.maxHybys; i++) {
      hybys[i].setBottomColor(wheel.getHSB(phaseCount, 255));
    }
    dt.setBottomColor(phaseCount, 0);
  }
  
  void setTopByPhaseCount() {
    for (int i = 0; i < field.maxHybys; i++) {
      hybys[i].setTopColor(wheel.getHSB(phaseCount, 255));
    }
    dt.setTopColor(phaseCount, 0);
  }
}
