class Bubble {
  int id, count; //add count
  float mag, depth, radius, lat, lon, incr, actualX, actualY, r, xPer, yPer; 
  color orange, red, c;
  boolean selected;

  Bubble(TableRow row) {
    //get id
    id = row.getInt("I_D");

    //get latitude and longitude
    lat = map(row.getFloat("LATITUDE"), -90, 90, height, 0);
    lon = map(row.getFloat("LONGITUDE"), -180, 180, 0, width);

    //X AND Y THAT WILL UPDATE
    actualX = lon;
    actualY = lat;
    xPer = 100*lon/width;
    yPer = 100*lat/height;
    float newW = width*pow(1.1, zoomCounter);
    float newH = height*pow(1.1, zoomCounter);
    actualX = transX+(newW*xPer/100);
    actualY = transY+(newH*yPer/100);


    //get depth and calculate radius
    depth = row.getInt("FOCAL_DEPTH");
    radius = map(depth, 0, 700, width*0.006, width*0.001);
    r = radius; //auxilar radius

    radius = radius*pow(1/1.1, zoomCounter); //ZOOMING

    //get magnitude
    mag = row.getFloat("EQ_PRIMARY");

    //set colors
    red = color(255, 102, 102);
    orange = color(255, 204, 102);

    //set selected
    selected = false;

    //set increase
    incr = width*0.00003*pow(1/1.1, zoomCounter); //ZOOMING
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


  //THE CHANGING CURSOR THING DOESN'T WORK
  void isClicked(int c) { //receives 0 or 1
    if (mouseX <= actualX+r && mouseX >= actualX-r && mouseY <= actualY+r && mouseY >= actualY-r) {
     // cursor(HAND); //hand icon if it's inside the area of the ellipse
      
      if (c == 1) { //if receives 1, the ellipse is selected
        //cursor(ARROW);
        selected = true;
      }
      
    } else {
      //cursor(ARROW); //arrow icon if it's outside the area of the ellipse
    }
  }


  void noClicked() {
    selected = false;
  }

  //CHANGE RADIUS WHILE ZOOMING
  void changeRadius(float f, float v) {
    float prev = radius;
    if (v <= 1) {
      radius = r;
      actualX = lon;
      actualY = lat;
    } else if (v>= pow(1.1, 20)) {
      radius = prev;
    } else {
      radius *=(1/f);
      actualX -= mouseX;
      actualY -= mouseY;
      actualX *=f;
      actualY *=f;
      incr *= (1/f);
      actualX += mouseX;
      actualY += mouseY;
    }
  }

  void changeActualPos() {
    actualX = actualX+mouseX-pmouseX;
    actualY = actualY+mouseY-pmouseY;
  }

  void limitLonLat(int l, int zoom) {
    float newW = width*pow(1.1, zoom);
    float newH = height*pow(1.1, zoom);
    switch(l) {
    case 1:
      actualX = transX+(newW*xPer/100);
      break;
    case 2:
      actualY = transY+(newH*yPer/100);
      // actualY = newH*yPer/100;
      break;
    case 3:
      actualX = transX+(newW*xPer/100);
      break;
    case 4:
      actualY = transY+(newH*yPer/100);
      break;
    default:
      break;
    }
  }
}
