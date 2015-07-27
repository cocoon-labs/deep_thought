class Field {
  
  Hyby[] hybys;
  DeepThought dt;
  ColorWheel wheel;
  int nHybys = 2;
  int maxHybys = 4;
  int nModes = 1;
  int nToggleModes = 5;
  Mode[] modes = new Mode[nModes];
  Mode[] toggleModes = new Mode[nToggleModes];
  int mode = 0;
  boolean dc_mode = false;
  Controller ctrl;
  
  // [hybys 0-3][top / bottom][x / y] 
  int[][][] hybyLightPositions = { { { 177, 373 }, { 179, 493 } },
                                   { { 376, 368 }, { 383, 454 } },
                                   { { 846, 368 }, { 843, 456 } },
                                   { { 1054, 388 }, { 1053, 496 } } };
  
  // [dt top / bottom][index clockwise from left][x / y]
  int[][][] dtLightPositions = { { {566, 291}, {582, 271}, {617, 270}, {655, 280}, {661, 309} },
                                 { {560, 434}, {568, 420}, {594, 418}, {623, 422}, {655, 439} } };

  Field(int chance, Controller ctrl, ColorWheel wheel) {
    this.ctrl = ctrl;
    hybys = new Hyby[maxHybys];
    this.wheel = wheel;
    //wheel.setPreset(2);

    for (int i = 0; i < maxHybys; i++) {
      hybys[i] = new Hyby(i, ctrl, wheel, new int[] {i * 2, i * 2 + 1}, hybyLightPositions[i]);
    }

    dt = new DeepThought(ctrl, wheel, dtLightPositions);

    //modes[0] = new GradientWipe(hybys, dt, wheel, 0.99, chance);
    modes[0] = new HueWipe(hybys, dt, wheel, 0.99, chance);
    toggleModes[2] = new DirectControl(hybys, dt, wheel, 0.99, chance);
  }

  public void send() {
    for (int i = 0; i < nHybys; i++) {
      hybys[i].ship();
    }
    dt.ship();
  }

  public void update() {
    if (dc_mode) {
      toggleModes[T_DC].advance();
    } else {
      modes[mode].advance();
    }
  }
  
  public void setMode(int m) {
    mode = m % nModes;
    modes[mode].reset();
  }
  
  public void draw() {
    for (int i = 0; i < maxHybys; i++) {
      hybys[i].draw(i);
    }
    dt.draw();
  }
  
}
