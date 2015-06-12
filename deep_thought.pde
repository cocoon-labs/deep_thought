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

int time;
boolean isOn = false;
boolean canDraw = false;
int hue = 100;
int bri = 0;
Controller ctrl;

void setup() {
  time = millis();
  ctrl = new Controller();
  // TODO: maybe set up the heartbeat if it seems relevant.
}

void draw () {
  
  int curr = millis();
  if ((curr - time) > 100 && canDraw) {
    time = curr;
    PHLightState lightState = new PHLightState();
    // cycle through some hues for the two connected lights.
    lightState.setHue((hue += 500) % 50000);
    ctrl.updateLight(0, lightState);
    ctrl.updateLight(1, lightState);
    //turn the light off
  }   
}

