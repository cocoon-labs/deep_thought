public abstract class Mode {
  
  // variables and stuff
  
  public Mode() {
    setDefault();
  }
  
  void setDefault() {
    // set variables to defaults
  }
  
  void setOption(int option) {
    // set variables somehow according to Trellis option selected
    // ideas:
    // -flip direction of movement; maybe direction of movement variable?
    // -turn on/off variables like randomness
  }
  
  void update() {
    // send stuff to lights
  }
  
}
