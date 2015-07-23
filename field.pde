class Field {
  
  Hyby[] hybys;
  DeepThought dt;
  ColorWheel wheel;
  int nHybys;
  int nModes = 1;
  Mode[] modes = new Mode[nModes];
  int mode = 0;
  Controller ctrl;

  Field(int chance, Controller ctrl) {
    this.ctrl = ctrl;
    nHybys = 2;
    hybys = new Hyby[nHybys];
    wheel = new ColorWheel();
    for (int i = 0; i < nHybys; i++) {
      hybys[i] = new Hyby(i, ctrl, wheel, i * 2, i * 2 + 1);
    }
    dt = new DeepThought();

    modes[0] = new RotateColors(hybys, dt, wheel, 0.99, chance);
  }

  public void send() {
    for (int i = 0; i < nHybys; i++) {
      hybys[i].ship();
    }
  }

  public void update() {
    modes[mode].advance();
  }
  
}