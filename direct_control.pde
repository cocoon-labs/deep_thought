public class DirectControl extends Mode {
  
  int[][] objWP = new int[nHybys + 1][2];
  int[][] objBright = new int[nHybys + 1][2];
  Joystick js;
  Pot pTop, pBot;
  Sculpture obj;
  int step = 16;

  public DirectControl(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
    for (int i = 0; i < nHybys; i++) {
      objWP[i] = new int[] {0, 0};
      objBright[i] = new int[] {panel.pots[i*2].getState(), panel.pots[i*2+1].getState()};
      if (i < nHybys) {
        obj = hybys[i];
      } else {
        obj = dt;
      }
      obj.setTopColor(wheel.getHSB(objWP[i][0], 255));
      obj.setBottomColor(wheel.getHSB(objWP[i][1], 255));
      obj.setTopBrightness(objBright[i][0]);
      obj.setBottomBrightness(objBright[i][1]);
    }
  }
  
  public void update() {
    for (int i = 0; i < nHybys + 1; i++) {
      int direction;

      if (i < nHybys) {
        obj = hybys[i];
      } else {
        obj = dt;
      }

      js = panel.joysticks[i];
      if (js.stateChanged) {
        direction = js.getDirection();
        if (direction == js.UL) {
          incTopWP(i, obj, 1);
          incBotWP(i, obj, -1);
        } else if (direction == js.UR) {
          incTopWP(i, obj, 1);
          incBotWP(i, obj, 1);
        } else if (direction == js.DL) {
          incTopWP(i, obj, -1);
          incBotWP(i, obj, -1);
        } else if (direction == js.DR) {
          incTopWP(i, obj, -1);
          incBotWP(i, obj, 1);
        } else if (direction == js.U) {
          incTopWP(i, obj, 1);
        } else if (direction == js.D) {
          incTopWP(i, obj, -1);
        } else if (direction == js.L) {
          incBotWP(i, obj, -1);
        } else if (direction == js.R) {
          incBotWP(i, obj, 1);
        }
      }

      pTop = panel.pots[i*2];
      pBot = panel.pots[i*2+1];
      if (pTop.stateChanged) {
        obj.setTopBrightness((int) map(pTop.getState(), 0, 1023, 0, 255));
      }
      if (pBot.stateChanged) {
        obj.setBottomBrightness((int) map(pTop.getState(), 0, 1023, 0, 255));
      }
    }
  }

  public void incTopWP(int idx, Sculpture obj, int dir) {
    objWP[idx][0] += (dir * step);
    obj.setTopColor(wheel.getHSB(objWP[idx][0], 255));
  }

  public void incBotWP(int idx, Sculpture obj, int dir) {
    objWP[idx][1] += (dir * step);
    obj.setBottomColor(wheel.getHSB(objWP[idx][1], 255));
  }

  public void incTopBright(int idx, Sculpture obj, int dir) {
    objBright[idx][0] += (dir * step);
    obj.setTopBrightness(objBright[idx][0]);
  }
  
  public void incBotBright(int idx, Sculpture obj, int dir) {
    objBright[idx][1] += (dir * step);
    obj.setBottomBrightness(objBright[idx][1]);
  }

}
