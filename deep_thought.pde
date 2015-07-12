import java.util.List;

import com.philips.lighting.hue.sdk.utilities.impl.*;
import org.json.hue.*;
import com.philips.lighting.annotations.*;
import com.philips.lighting.hue.listener.*;
import com.philips.lighting.hue.sdk.bridge.impl.*;
import com.philips.lighting.model.sensor.*;
import com.philips.lighting.hue.sdk.utilities.*;
import com.philips.lighting.hue.sdk.fbp.*;
import com.philips.lighting.model.rule.*;
import com.philips.lighting.model.*;
import com.philips.lighting.hue.sdk.exception.*;
import com.philips.lighting.model.sensor.metadata.*;
import com.philips.lighting.hue.sdk.clip.serialisation.*;
import com.philips.lighting.hue.sdk.clip.*;
import com.philips.lighting.hue.sdk.clip.serialisation.sensors.*;

import com.philips.lighting.hue.sdk.*;
import com.philips.lighting.hue.sdk.data.*;
import com.philips.lighting.hue.sdk.connection.impl.*;
import com.philips.lighting.hue.sdk.util.*;
import com.philips.lighting.hue.sdk.upnp.*;
import com.philips.lighting.hue.sdk.notification.impl.*;
import com.philips.lighting.hue.sdk.heartbeat.*;

import processing.serial.*;
import cc.arduino.*;

import oscP5.*;
import netP5.*;

Arduino arduino;
Trellis trellis;
Toggle[] toggles;
Joystick[] joysticks;
Pot[] pots;
Fader[] faders;
Pulse pulse;
Proximity prox;

boolean changed = false;

// Toggle references
int T_PRESETS = 0;
int T_WC = 1;
int T_DC = 2;
int T_ARCADE = 3;
int T_DEST = 4;

int time = 0;
int debounce = 200;

boolean isOn = false;
boolean canDraw = false;
int hue = 100;
int bri = 0;
Controller ctrl;
int[] hues = new int[] {2000, 50000};
int[] brightnesses = new int[] {0, 128};
int js_bright = brightnesses[0];
int js_hue = hues[0];

// Lighting mode stuff
// nModes = number of lighting modes
// mode = ID of lighting mode currently selected
// modes[mode] = actual lighting mode currently selected
// modeOptions[mode] = how many specific options to display on Trellis for given mode
// ... then lighting modes. CIRCLE is just an example name, i.e. circles through wheel.
int nModes = 0;
int mode = CIRCLE;
Mode[] modes = new Modes[nModes];
int[] modeOptions = new int[] {5}; // 5 is just a place holder for now
int CIRCLE = 0;

ColorWheel wheel = new ColorWheel();

// OSC Stuff
OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddressList myNetAddressList = new NetAddressList();
int myListeningPort = 5001;
int myBroadcastPort = 12000;

void setup() {
    time = millis();
    ctrl = new Controller();
    // TODO: maybe set up the heartbeat if it seems relevant.

    println(Arduino.list());
    // for raspi
    arduino = new Arduino (this, Arduino.list()[0], 57600);
    
    println(Serial.list());
    // THIS WILL PROBABLY HAVE TO BE MODIFIED
    // TO CONNECT WITH THE RIGHT SERIAL PORT
    Serial trellisPort = new Serial(this, Serial.list()[0], 9600);
    trellis = new Trellis(trellisPort);

    // for macbook
    // arduino = new Arduino (this, Arduino.list()[2], 57600);

    toggles = new Toggle[] {
      new Toggle(22), new Toggle(24), new Toggle(26),
      new Toggle(28), new Toggle(30)
    };

    joysticks = new Joystick[] {
      new Joystick(32, 35, 36, 38), new Joystick(40, 42, 46, 48),
      new Joystick(31, 33, 35, 37), new Joystick(39, 41, 43, 45),
      new Joystick(47, 49, 51, 53)
    };

    pots = new Pot[] {
      new Pot(0), new Pot(1), new Pot(2), new Pot(3), new Pot(4),
      new Pot(5), new Pot(6), new Pot(7), new Pot(8), new Pot(9)
    };

    faders = new Fader[] {
      new Fader(10), new Fader(11), new Fader(12), new Fader(13), new Fader(14)
    };

    pulse = new Pulse(15);
    prox = new Proximity(49);

    // This causes firmata to wake up, for some reason. Needed for PI.
    arduino.pinMode(13, Arduino.OUTPUT);

    oscP5 = new OscP5(this, myListeningPort);

    // set the remote location to be the dt_matrix raspberry pi
    myRemoteLocation = new NetAddress("192.168.2.122", 5005);
    
    trellis.updateMode();
}

void draw () {

  PHLightState lightOneState = new PHLightState();
  PHLightState lightTwoState = new PHLightState();
  
//   if (millis() - time > debounce) {
//   int next = val == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
//   arduino.digitalWrite(13, next);
//   val = next;
// }

  checkToggles();
  trellis.recordState();
  
  // THIS SOMEWHERE INSIDE SOME TIMED LOOP
  // modes[mode].update();

  if (canDraw && (millis() - time > debounce) && pots[0].recordState()) {
    int bright = (int) map(pots[0].getState(), 0, 1023, 0, 255);
    lightOneState.setBrightness(bright);
    lightTwoState.setBrightness(bright);

    ctrl.updateLight(0, lightOneState);
    ctrl.updateLight(1, lightTwoState);
    
    tellThem();
    time = millis();
  }

  // if (canDraw && switches_changed()) {
  //   // cycle through some hues for the two connected lights.
  //   js_hue = hues[t3_reading];
  //   // js_bright = brightnesses[t5_reading];
  //   lightOneState.setOn((t1_reading == 1) ? true : false);
  //   lightTwoState.setOn((t2_reading == 1) ? true : false);
  // }

  // if (canDraw && joystick_engaged() && (millis() - time > debounce)) {
  //   if (ju_reading == Arduino.LOW) {
	//     println("increment bright");
	//     js_bright += 16;
  //   } else if (jd_reading == Arduino.LOW) {
	//     js_bright -= 16;
  //   }

  //   if (jl_reading == Arduino.LOW) {
	//     js_hue -= 1000;
  //   } else if (jr_reading == Arduino.LOW) {
	//     js_hue += 1000;
  //   }

  //   js_bright = constrain(js_bright, 0, 255);

  //   js_hue = constrain(js_hue, 0, 50000);
  //   // println(ju_reading + " : " + jd_reading + " : " + jl_reading + " : " + jr_reading);
	
  // }

  // if (canDraw && check_for_change() && (millis() - time > debounce)) {
  //   lightOneState.setBrightness(js_bright);
  //   lightTwoState.setBrightness(js_bright);

  //   lightOneState.setHue(js_hue);
  //   lightTwoState.setHue(js_hue);

  //   ctrl.updateLight(0, lightOneState);
  //   ctrl.updateLight(1, lightTwoState);

  //   time = millis();
  // }

}

// boolean check_for_change() {
//   return switches_changed() || joystick_engaged();
// }

// boolean joystick_engaged() {
//   return ju_reading == Arduino.LOW || jd_reading == Arduino.LOW || 
//     jl_reading == Arduino.LOW || jr_reading == Arduino.LOW;
// }

void tellThem() {
  print("sending osc");
  OscMessage message;
  message = new OscMessage("/pot/0");
  message.add(pots[0].getState());
  oscP5.send(message, myRemoteLocation);
}

void checkToggles() {
  boolean trellisModeChanged = false;
  if (toggles[T_PRESETS].recordState()) {
    trellisModeChanged = true;
  }
  if (toggles[T_WC].recordState()) {
    
  }
  if (toggles[T_DC].recordState()) {
    trellisModeChanged = true;
  }
  if (toggles[T_ARCADE].recordState()) {
    trellisModeChanged = true;
  }
  if (toggles[T_DEST].recordState()) {
    trellisModeChanged = true;
  }
  if (trellisModeChanged) {
    trellis.updateMode();
  }
}

// Called when color preset is selected via Trellis
void selectColorPreset(int c) {
  wheel.setPreset(c);
}

// Called when mode preset is selected via Trellis
void selectModePreset(int m) {
  // mode = m;
  // modes[mode].setDefault();
  // OR SOMETHING LIKE THAT
}

void selectModeOption(int optionSelected) {
  // modes[mode].setOption(optionSelected);
  // OR SOMETHING LIKE THAT
}

// void stop() {
//     OscMessage message;
//     message = new OscMessage("/quit");
//     oscP5.send(message, myRemoteLocation);
// }
