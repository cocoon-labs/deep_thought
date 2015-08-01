class Panel {
  
  Toggle[] toggles;
  Joystick[] joysticks;
  Pot[] pots;
  Fader[] faders;
  Pulse pulse;
  Proximity prox;
  CoinAcceptor coin;

  Panel() {
    
    toggles = new Toggle[] {
      new Toggle(22, 690, 792), new Toggle(23, 706, 792), new Toggle(26, 722, 792),
      new Toggle(28, 738, 792), new Toggle(30, 754, 792)
    };

    joysticks = new Joystick[] {
      new Joystick(32, 35, 36, 38, 404, 793), new Joystick(40, 42, 46, 48, 460, 793),
      new Joystick(31, 33, 35, 37, 516, 793), new Joystick(39, 41, 43, 45, 572, 793),
      new Joystick(47, 49, 51, 53, 628, 793)
    };

    pots = new Pot[] {
      new Pot(0, 396, 835), new Pot(1, 413, 835), new Pot(2, 452, 835), new Pot(3, 469, 835), new Pot(4, 508, 835),
      new Pot(5, 525, 835), new Pot(6, 564, 835), new Pot(7, 581, 835), new Pot(8, 620, 835), new Pot(9, 637, 835)
    };

    faders = new Fader[] {
      new Fader(10, 404, 893), new Fader(11, 460, 893), new Fader(12, 516, 893), new Fader(13, 572, 893), new Fader(14, 628, 893)
    };

    pulse = new Pulse(15, 433, 716);
    prox = new Proximity(49, 875, 899);
    coin = new CoinAcceptor(2, 10, 0, 0);
    // distance beam
    
  }
  
  void check() {
    
    // checkToggles();
    checkToggles(1);
    checkJoysticks();
    checkPots();
    checkFaders();
    checkPulse();
    checkProx();
    checkBeam();
    //checkCoin();
    // check distance beam
    // trellis.check();
    
  }

  void checkToggles() {
    for (int i = 0; i < toggles.length; i++) {
      toggles[i].recordState();
    }
  }
  
  /* Mapped toggles to keyboard.
     1-5 toggle on
     a-e toggle off
  */
  void checkToggles(int q) {
    for (int i = 0; i < toggles.length; i++) {
      toggles[i].stateChanged = false;
      if (key - '1' == i) {
        if (toggles[i].getState() == Arduino.LOW) {
          toggles[i].stateChanged = true;
        }
        toggles[i].state = Arduino.HIGH;
      } else if (key - 'a' == i) {
        if (toggles[i].getState() == Arduino.HIGH) {
          toggles[i].stateChanged = true;
        }
        toggles[i].state = Arduino.LOW;
      }
    }
  }
  
  void checkJoysticks() {
    for (int i = 0; i < joysticks.length; i++) {
      joysticks[i].recordState();
    }
  }
  
  void checkPots() {
    for (int i = 0; i < pots.length; i++) {
      pots[i].recordState();
    }
  }

  void checkFaders() {
    for (int i = 0; i < faders.length; i++) {
      faders[i].recordState();
    }
  }

  void checkPulse() {
    pulse.recordState();
  }

  void checkProx() {
    prox.recordState();
  }

  void checkCoin() {
    coin.recordState();
  }
  
  void draw() {
    
    image(panelImage, 0, height - panelImage.height);
    
    for (int i = 0; i < toggles.length; i++) {
      toggles[i].draw();
    }
    for (int i = 0; i < joysticks.length; i++) {
      joysticks[i].draw();
    }
    for (int i = 0; i < pots.length; i++) {
      pots[i].draw();
    }
    for (int i = 0; i < faders.length; i++) {
      faders[i].draw();
    }
    pulse.draw();
    prox.draw();
    trellis.draw();
    
  }

}
