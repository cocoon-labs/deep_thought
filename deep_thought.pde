import java.util.List;
import java.util.Collections;
import java.util.Comparator;

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

import java.awt.Color;
import java.util.Random;

Arduino arduino;
Trellis trellis;
Panel panel;

boolean changed = false;
int globalBrightness = 0;
PImage bgImage, panelImage;
int bgOffset = 60;

// Toggle references
int T_PRESETS = 0;
int T_WC = 1;
int T_DC = 2;
int T_ARCADE = 3;
int T_DEST = 4;

int time = 0;
int debounce = 1000;
int buttonDebounce = 200;
int presstime = 0;

boolean isOn = false;
boolean canDraw = false;
int hue = 100;
int bri = 0;
Controller ctrl;
Field field;
Matrix matrix;
int[] hues = new int[] {2000, 50000};
int[] brightnesses = new int[] {0, 128};
int js_bright = brightnesses[0];
int js_hue = hues[0];

ColorWheel wheel;
Random rand;

// OSC Stuff
OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddressList myNetAddressList = new NetAddressList();
int myListeningPort = 5001;
int myBroadcastPort = 12000;

boolean noSerial = false;

void setup() {
  //size(screenSize, screenSize);
  //background(0);
  rand = new Random();
  bgImage = loadImage("hybycozo.jpg");
  panelImage = loadImage("panel.jpg");
  size(bgImage.width, bgImage.height + panelImage.height - 160);
  ellipseMode(RADIUS);
  
  wheel = new ColorWheel();
  time = millis();
  ctrl = new Controller();
  // TODO: maybe set up the heartbeat if it seems relevant.

  if (!noSerial) {
    println(Arduino.list());
    // for raspi
    arduino = new Arduino (this, Arduino.list()[1], 57600);
  
    // for macbook
    // arduino = new Arduino (this, Arduino.list()[2], 57600);
    
    // This causes firmata to wake up, for some reason. Needed for PI.
    arduino.pinMode(13, Arduino.OUTPUT);
    
    panel = new Panel();
    Serial trellisPort = new Serial(this, Serial.list()[0], 9600);
    trellis = new Trellis(trellisPort);

    oscP5 = new OscP5(this, myListeningPort);
  
    // set the remote location to be the dt_matrix raspberry pi
    myRemoteLocation = new NetAddress("192.168.2.122", 5005);
  }
  
  field = new Field(500, ctrl, wheel);
  
  if (!noSerial) {
    matrix = new Matrix();
    
    panel.check();
    delay(1000);
    trellis.init();
  }
  
  field.init();
    
}

void draw () {

  // PHLightState lightOneState = new PHLightState();
  // PHLightState lightTwoState = new PHLightState();
  
//   if (millis() - time > debounce) {
//   int next = val == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
//   arduino.digitalWrite(13, next);
//   val = next;
// }

  // panel.checkToggles();
  // trellis.recordState();
  
  panel.check();
  
  if (canDraw && ((millis() - time) > debounce)) {
    field.update();
    field.send();
    // int bright = (int) map(pots[0].getState(), 0, 1023, 0, 255);
    // lightOneState.setBrightness(bright);
    // lightTwoState.setBrightness(bright);

    // ctrl.updateLight(0, lightOneState);
    // ctrl.updateLight(1, lightTwoState);
    
    // tellThem();
    time = millis();
  }
  
  image(bgImage, 0, -bgOffset);
  field.draw();
  panel.draw();

  matrix.update();

}

public void keyPressed() {

  print("Keypressed");
  
  if ((millis() - presstime) > buttonDebounce) {
    if (key == '1') {
      panel.toggles[0].stateChanged = true;
      panel.toggles[0].state = panel.toggles[0].state == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
    } else if (key == '2') {
      panel.toggles[1].stateChanged = true;
      panel.toggles[1].state = panel.toggles[1].state == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
    } else if (key == '3') {
      panel.toggles[2].stateChanged = true;
      panel.toggles[2].state = panel.toggles[2].state == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
    } else if (key == '4') {
      panel.toggles[3].stateChanged = true;
      panel.toggles[3].state = panel.toggles[3].state == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
    } else if (key == '5') {
      panel.toggles[4].stateChanged = true;
      panel.toggles[4].state = panel.toggles[4].state == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
    }
    presstime = millis();
  }
}


//void tellThem() {
//  print("sending osc");
//  OscMessage message;
//  message = new OscMessage("/pot/0");
//  message.add(pots[0].getState());
//  oscP5.send(message, myRemoteLocation);
//}

// void exit() {
//   println("stopping");
//     OscMessage message;
//     message = new OscMessage("/quit");
//     oscP5.send(message, myRemoteLocation);
//     super.exit();
// }
