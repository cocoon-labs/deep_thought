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

int SWITCH1 = 22;
int SWITCH2 = 24;
int SWITCH3 = 26;
int SWITCH4 = 28;
// int SWITCH5 = 30;

// For this orientation, down is the direction of the headers
int JS_UP = 32;
int JS_DOWN = 34;
int JS_LEFT = 36;
int JS_RIGHT = 38;

int s1_state = Arduino.LOW;
int s2_state = Arduino.LOW;
int s3_state = Arduino.LOW;
int s4_state = Arduino.LOW;
// int s5_state = Arduino.LOW;

int ju_state = Arduino.LOW;
int jd_state = Arduino.LOW;
int jl_state = Arduino.LOW;
int jr_state = Arduino.LOW;

int s1_reading = Arduino.LOW;
int s2_reading = Arduino.LOW;
int s3_reading = Arduino.LOW;
int s4_reading = Arduino.LOW;
// int s5_reading = Arduino.LOW;

int ju_reading = Arduino.LOW;
int jd_reading = Arduino.LOW;
int jl_reading = Arduino.LOW;
int jr_reading = Arduino.LOW;

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

    arduino.pinMode(SWITCH1, Arduino.INPUT);
    arduino.pinMode(SWITCH2, Arduino.INPUT);
    arduino.pinMode(SWITCH3, Arduino.INPUT);
    arduino.pinMode(SWITCH4, Arduino.INPUT);
    // arduino.pinMode(SWITCH5, Arduino.INPUT);

    arduino.pinMode(JS_UP, Arduino.INPUT);
    arduino.pinMode(JS_DOWN, Arduino.INPUT);
    arduino.pinMode(JS_LEFT, Arduino.INPUT);
    arduino.pinMode(JS_RIGHT, Arduino.INPUT);
    arduino.digitalWrite(JS_UP, Arduino.HIGH);
    arduino.digitalWrite(JS_DOWN, Arduino.HIGH);
    arduino.digitalWrite(JS_LEFT, Arduino.HIGH);
    arduino.digitalWrite(JS_RIGHT, Arduino.HIGH);

}

void draw () {

    s1_reading = arduino.digitalRead(SWITCH1);
    s2_reading = arduino.digitalRead(SWITCH2);
    s3_reading = arduino.digitalRead(SWITCH3);
    s4_reading = arduino.digitalRead(SWITCH4);
    // s5_reading = arduino.digitalRead(SWITCH5);

    ju_reading = arduino.digitalRead(JS_UP);
    jd_reading = arduino.digitalRead(JS_DOWN);
    jl_reading = arduino.digitalRead(JS_LEFT);
    jr_reading = arduino.digitalRead(JS_RIGHT);

    PHLightState lightOneState = new PHLightState();
    PHLightState lightTwoState = new PHLightState();

    if (canDraw && switches_changed()) {
        // cycle through some hues for the two connected lights.
	js_hue = hues[s3_reading];
	// js_bright = brightnesses[s5_reading];
        lightOneState.setOn((s1_reading == 1) ? true : false);
        lightTwoState.setOn((s2_reading == 1) ? true : false);
    }

    if (canDraw && joystick_engaged() && (millis() - time > debounce)) {
	if (ju_reading == Arduino.LOW) {
	    println("increment bright");
	    js_bright += 16;
	} else if (jd_reading == Arduino.LOW) {
	    js_bright -= 16;
	}

	if (jl_reading == Arduino.LOW) {
	    js_hue -= 1000;
	} else if (jr_reading == Arduino.LOW) {
	    js_hue += 1000;
	}

	js_bright = constrain(js_bright, 0, 255);

	js_hue = constrain(js_hue, 0, 50000);
	// println(ju_reading + " : " + jd_reading + " : " + jl_reading + " : " + jr_reading);
	
    }

    if (canDraw && check_for_change() && (millis() - time > debounce)) {
	lightOneState.setBrightness(js_bright);
	lightTwoState.setBrightness(js_bright);

	lightOneState.setHue(js_hue);
	lightTwoState.setHue(js_hue);

        ctrl.updateLight(0, lightOneState);
        ctrl.updateLight(1, lightTwoState);

	time = millis();
    }

    s1_state = s1_reading;
    s2_state = s2_reading;
    s3_state = s3_reading;
    s4_state = s4_reading;
    // s5_state = s5_reading;

    ju_state = ju_reading;
    jd_state = jd_reading;
    jl_state = jl_reading;
    jr_state = jr_reading;

}

boolean check_for_change() {
    return switches_changed() || joystick_engaged();
}

boolean joystick_engaged() {
    return ju_reading == Arduino.LOW || jd_reading == Arduino.LOW || 
	jl_reading == Arduino.LOW || jr_reading == Arduino.LOW;
}

boolean switches_changed() {
    return s1_reading != s1_state || s2_reading != s2_state ||
        s3_reading != s3_state || s4_reading != s4_state;
        // s5_reading != s5_state;
}
