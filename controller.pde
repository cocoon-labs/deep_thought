public class Controller {
  String hybyBridgeIP = "192.168.2.200";
  String deepThoughtBridgeIP = "192.168.2.234";
  String hybyBridgeUname = "newdeveloper";
  String deepThoughtBridgeUname = "2be6d1f789c9c5f4e087e72569e46f";
  PHHueSDK phHueSDK = PHHueSDK.getInstance();
  PHAccessPoint hybyAccessPoint = new PHAccessPoint();
  PHAccessPoint deepThoughtAccessPoint = new PHAccessPoint();
  
  PHBridge bridge;
  PHBridgeResourcesCache cache; 
  PHBridge[] bridges = new PHBridge[2];
  List<PHLight> allLightsTmp;
  PHLight[] allLights = new PHLight[1];
  PHLight[][] lights = new PHLight[2][];
  
  
  // Local SDK Listener
  PHSDKListener listener = new PHSDKListener() {

        @Override
        public void onAccessPointsFound(List accessPoint) {
             // Handle your bridge search results here.  Typically if multiple results are returned you will want to display them in a list 
             // and let the user select their bridge.   If one is found you may opt to connect automatically to that bridge.            
        }
        
        @Override
        public void onCacheUpdated(List cacheNotificationsList, PHBridge bridge) {
             // Here you receive notifications that the BridgeResource Cache was updated. Use the PHMessageType to   
             // check which cache was updated, e.g.
            if (cacheNotificationsList.contains(PHMessageType.LIGHTS_CACHE_UPDATED)) {
               System.out.println("Lights Cache Updated ");
            }
        }

        @Override
        public void onBridgeConnected(PHBridge b, String username) {
            phHueSDK.setSelectedBridge(b);
            
            phHueSDK.enableHeartbeat(b, PHHueSDK.HB_INTERVAL);
            bridge = phHueSDK.getSelectedBridge();
            cache = bridge.getResourceCache();
            allLightsTmp = cache.getAllLights();
            Collections.sort(allLightsTmp, new Comparator<PHLight>() {
                public int compare(PHLight o1, PHLight o2) {
                  return o1.getIdentifier().compareTo(o2.getIdentifier());
                }
              });
            allLights = allLightsTmp.toArray(allLights);
            if (allLights.length == 4) {
              bridges[0] =  b;
              lights[0] = allLights;
            } else {
              bridges[1] = b;
              lights[1] =  allLights;
            }

            if (bridges[0] != null && bridges[1] != null) {
              println("Both bridges discovered. Ready to Paint the HybyCozo Red.");
              canDraw = true;
            }
            // Here it is recommended to set your connected bridge in your sdk object (as above) and start the heartbeat.
            // At this point you are connected to a bridge so you should pass control to your main program/activity.
            // Also it is recommended you store the connected IP Address/ Username in your app here.  This will allow easy automatic connection on subsequent use. 
        }

        @Override
        public void onAuthenticationRequired(PHAccessPoint accessPoint) {
            phHueSDK.startPushlinkAuthentication(accessPoint);
            // Arriving here indicates that Pushlinking is required (to prove the User has physical access to the bridge).  Typically here
            // you will display a pushlink image (with a timer) indicating to to the user they need to push the button on their bridge within 30 seconds.
        }

        @Override
        public void onConnectionResumed(PHBridge bridge) {

        }

        @Override
        public void onConnectionLost(PHAccessPoint accessPoint) {
             // Here you would handle the loss of connection to your bridge.
        }
        
        @Override
        public void onError(int code, final String message) {
             // Here you can handle events such as Bridge Not Responding, Authentication Failed and Bridge Not Found
        }

        @Override
        public void onParsingErrors(List parsingErrorsList) {
            // Any JSON parsing errors are returned here.  Typically your program should never return these.      
        }
  };
  
  public Controller() {
    phHueSDK.setAppName("SomeApp");
    phHueSDK.getNotificationManager()
      .registerSDKListener(listener);
    println("listener registered");
    hybyAccessPoint.setIpAddress(hybyBridgeIP);
    hybyAccessPoint.setUsername(hybyBridgeUname);
    phHueSDK.connect(hybyAccessPoint);

    deepThoughtAccessPoint.setIpAddress(deepThoughtBridgeIP);
    deepThoughtAccessPoint.setUsername(deepThoughtBridgeUname);
    phHueSDK.connect(deepThoughtAccessPoint);
    
  }
  
  public void updateLight(int bridgeIdx, int lightIdx, PHLightState lightState) {
    allLights = lights[bridgeIdx];
    bridge = bridges[bridgeIdx];
    bridge.updateLightState(allLights[lightIdx], lightState);
  }
  
}
