class Bubble {
  int id, count; //add count
  float mag, depth, radius, lat, lon, incr; //add increase value
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

    //set increase
    incr = width*0.00003;
    count = (int)random(0, 50);
 
  }

  void display(float maxMag, float minMag, boolean sD) {
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

    //First we draw the shadow
    dropShadow();

    //Then we draw the ellipse
    fill(c); 
    ellipse(lon, lat, radius, radius);    


    if (!sD) { //if showDetails == false
      if (count == 50) {
        incr = -incr;
        count = 0;
      }
      radius += incr;
      count++;
    }
    
  }

  void dropShadow() {
    //save the radius in a new auxiliar variable
    float aux = radius;

    for (int i=16; i>=0; i-=2) {
      fill(100, 100, 100, i); //fill color with less opacity each time
      noStroke();
      ellipse(lon, lat, aux, aux);
      aux+=aux*0.08; //shadow radius increases
    }
  }

 
  void isClicked(int c) { //receives 0 or 1
    if (mouseX < lon+radius && mouseX > lon-radius && mouseY < lat+radius && mouseY > lat-radius) {
       cursor(HAND);
      if(c == 1){
        cursor(ARROW);
        selected = true;
      }      
    }
  }


  void noClicked() {
    selected = false;
  }
}
