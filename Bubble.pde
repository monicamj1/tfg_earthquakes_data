class Bubble {
  int id;
  float mag, depth, radius, lat, lon;
  color orange, red, c;
  boolean selected;

  Bubble(TableRow row) {
    //get id
    id = row.getInt("I_D");

    //get latitude and longitude
    lat = map(row.getFloat("LATITUDE"), -90, 90, height, 0);
    lon = map(row.getFloat("LONGITUDE"), -180, 180, 0, width);

    //get depth and calculate radius
    depth = row.getInt("FOCAL_DEPTH");
    radius = map(depth, 0, 700, width*0.006, width*0.001);

    //get magnitude
    mag = row.getFloat("EQ_PRIMARY");

    //set colors
    red = color(255, 102, 102);
    orange = color(255, 204, 102);

    //set selected
    selected = false;
  }

  void display(float maxMag, float minMag) {
    ellipseMode(RADIUS);
    noStroke(); 

    //maxMag*a + b = 1
    //minMag*a + b = 0
    float a = 1/(maxMag-minMag);
    float b = -minMag*a;
    float interpolation = (mag*a+b);
    c = lerpColor(orange, red, interpolation);

    //if there is no mag value, set a grey color
    if (Float.isNaN(mag)) {
      c = color(150, 150, 150);
    } 
    dropShadow();
    fill(c); 
    ellipse(lon, lat, radius, radius);
    
  }
  
  void dropShadow(){
    float aux = radius;
    for(int i=16; i>=0; i-=2){
      fill(100,100,100,i);
      noStroke();
      ellipse(lon, lat, aux, aux);
      aux+=aux*0.08;
    }
  }

  //if the mouse clicked in the bubble area, then selected = true
  void isClicked() {
    if (mouseX < lon+radius && mouseX > lon-radius && mouseY < lat+radius && mouseY > lat-radius) {
      selected = true;
    }
  }


  void noClicked() {
    selected = false;
  }
}
