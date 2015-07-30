public class Pulsar extends Mode {
  
  // variables to link
  int loopStep;
  boolean synch;
  boolean topGoesIn, botGoesIn;
  
  int topPos, botPos;
  boolean topTurn;

  public Pulsar(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    super(hybys, dt, wheel, fadeFactor, chance);
  }

  public void update() {
    super.update();
    boolean shouldTurn = false;
    if (synch) {
      shouldTurn = updateTop();
      shouldTurn = updateBottom() || shouldTurn;
    } else {
      if (topTurn) {
        shouldTurn = updateTop();
      } else {
        shouldTurn = updateBottom();
      }
    }
    if (shouldTurn) {
      wheel.turn(loopStep);
      topTurn = !topTurn;
    }
  }
  
  public void setDefault() {
    loopStep = 100;
    synch = true;
    topGoesIn = false;
    botGoesIn = false;
    
    topPos = 2;
    botPos = 2;
    topTurn = true;
  }
  
  boolean updateTop() {
    boolean impact = false;
    if (topGoesIn) {
      if (topPos < 0 || topPos > 1) {
        dt.setTopColor(0, 0);
        topPos = 0;
        impact = true;
      } else {
        setTop(topPos, 0);
        setTop(nBulbs/2 - 1 - topPos, 0);
        topPos++;
      }
    } else {
      if (topPos < 0 || topPos > 1) {
        dt.setTopColor(0, 0);
        topPos = 1;
      } else {
        setTop(topPos, 0);
        setTop(nBulbs/2 - 1 - topPos, 0);
        topPos--;
        if (topPos < 0) impact = true;
      }
    }
    return impact;
  }
 
  boolean updateBottom() {
    boolean impact = false;
    if (botGoesIn) {
      if (botPos < 0 || botPos > 1) {
        dt.setBottomColor(0, 0);
        botPos = 0;
        impact = true;
      } else {
        setBottom(botPos, 0);
        setBottom(nBulbs/2 - 1 - botPos, 0);
        botPos++;
      }
    } else {
      if (botPos < 0 || botPos > 1) {
        dt.setBottomColor(0, 0);
        botPos = 1;
      } else {
        setBottom(botPos, 0);
        setBottom(nBulbs/2 - 1 - botPos, 0);
        botPos--;
        if (botPos < 0) impact = true;
      }
    }
    return impact;
  }
}
