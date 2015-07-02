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

Arduino arduino;
Toggle[] toggles;
Joystick[] joysticks;
Pot[] pots;
Fader[] faders;
Pulse pulse;
Proximity prox;

boolean changed = false;

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

void setup() {
    time = millis();
    ctrl = new Controller();
    // TODO: maybe set up the heartbeat if it seems relevant.

    println(Arduino.list());
    arduino = new Arduino (this, Arduino.list()[0], 57600);

    toggles = new Toggle[] {
      Toggle(22), Toggle(24), Toggle(26),
      Toggle(28), Toggle(30)
    };

    joysticks = new Joystick[] {
      Joystick(32, 35, 36, 38), JoyStick(40, 42, 46, 48),
      Joystick(31, 33, 35, 37), JoyStick(39, 41, 43, 45),
      Joystick(47, 49, 51, 53)
    };

    pots = new Pot[] {
      Pot(0), Pot(1), Pot(2), Pot(3), Pot(4),
      Pot(5), Pot(6), Pot(7), Pot(8), Pot(9)
    };

    faders = new Fader[] {
      Fader(10), Fader(11), Fader(12), Fader(13), Fader(14)
    };

    pulse = new Pulse(15);
    prox = new Proximity(49);
}

void draw () {

  PHLightState lightOneState = new PHLightState();
  PHLightState lightTwoState = new PHLightState();

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

// boolean switches_changed() {
//   return t1_reading != t1_state || t2_reading != t2_state ||
//     t3_reading != t3_state || t4_reading != t4_state;
//   // t5_reading != t5_state;
// }
