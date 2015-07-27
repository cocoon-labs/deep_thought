public class Mode {

  // variables and stuff
  Hyby[] hybys;
  DeepThought dt;
  ColorWheel wheel;
  float fadeFactor;
  int chance;
  int nHybys, nBulbs;
  
  public Mode(Hyby[] hybys, DeepThought dt, ColorWheel wheel, float fadeFactor, int chance) {
    setDefault();
    this.hybys = hybys;
    this.dt = dt;
    this.wheel = wheel;
    this.fadeFactor = fadeFactor;
    this.chance = chance;
    this.nHybys = hybys.length;
    
    //TODO: update this to include deep thought lights
    nBulbs = hybys.length * 2;
  }
  
  public void setDefault() {
    // set variables to defaults
  }
  
  public void setOption(int option) {
    // set variables somehow according to Trellis option selected
    // ideas:
    // -flip direction of movement; maybe direction of movement variable?
    // -turn on/off variables like randomness
  }
  
  public void advance() {
    update();
  }

  public void update() {
    // do stuff
  }
  
  public void reset() {
    // set defaults? possible option to go with mode preset selection via trellis
  }
  
}
