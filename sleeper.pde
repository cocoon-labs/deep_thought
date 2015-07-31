public class Sleeper {
  
  int maxSeconds;
  int hourLastTriggered, minLastTriggered, secLastTriggered;
  boolean sleeping = true;
  boolean justSlept, justWoke;
  
  public Sleeper(int minutes, int seconds) {
    maxSeconds = minutes * 60 + seconds;
    trigger();
  }
  
  public void trigger() {
    hourLastTriggered = hour();
    minLastTriggered = minute();
    secLastTriggered = second();
    if (sleeping = true) {
      justSlept = false;
      justWoke = true;
    } else {
      resetFlags();
    }
    sleeping = false;
  }
  
  public boolean isSleeping() {
    if (sleeping) return true;
    int currHour = hour();
    if (currHour - hourLastTriggered < 0) currHour += 24;
    int secTriggered = ((hourLastTriggered * 60) + minLastTriggered) * 60 + secLastTriggered;
    int currentSec = ((currHour * 60) + minute()) * 60 + second();
    int secondsPassed = currentSec - secTriggered;
    if (secondsPassed > maxSeconds) {
      sleeping = true;
      justSlept = true;
      return true;
    }
    else {
      sleeping = false;
      return false;
    }
  }
  
  public void resetFlags() {
    justSlept = false;
    justWoke = false;
  }
}
