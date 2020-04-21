Table table;
float lat, lon, depth, mag, maxMag, minMag, a, b;
color orange, red, c;
PShape map;
Slider slider;
IntList yearList;
int actualYear, newYear;

void setup() {
  //size (720, 480);
  fullScreen();

  map = loadShape("map.svg");



  red = color(255, 102, 102);
  orange = color(255, 204, 102);

  table = loadTable("database", "header, tsv"); 

  float[] magArray = new float[table.getRowCount()];

  yearList = new IntList(); //initialize yearList

  //get the first year of the table (the table is sorted by date)
  TableRow firstRow = table.getRow(0);
  actualYear = firstRow.getInt("YEAR");
  yearList.append(actualYear);


  for (int i=0; i<magArray.length; i++) {
    TableRow row = table.getRow(i);
    magArray[i] = row.getFloat("EQ_PRIMARY");

    newYear = row.getInt("YEAR");
    if (actualYear != newYear) {
      actualYear = newYear;
      yearList.append(actualYear);
    }
  }

  //initialize slider and send list
  slider = new Slider(yearList); 

  maxMag = max(magArray);
  minMag = min(magArray);
}

void draw() {

  shape(map, 0, 0, width, height); 

  for (TableRow row : table.findRows(str(yearList.get(slider.selected)), "YEAR")) {
    lat = map(row.getFloat("LATITUDE"), -90, 90, height, 0);
    lon = map(row.getFloat("LONGITUDE"), -180, 180, 0, width);

    depth = row.getInt("FOCAL_DEPTH");
    float r = map(depth, 0, 700, width*0.006, width*0.001);

    mag = row.getFloat("EQ_PRIMARY");

    ellipseMode(RADIUS);
    noStroke(); 
    /*
    maxMag*a + b = 1
     minMag*a + b = 0
     */
    a = 1/(maxMag-minMag);
    b = -minMag*a;
    float interpolation = (mag*a+b);
    c = lerpColor(orange, red, interpolation);
    fill(c); 
    ellipse(lon, lat, r, r);
  }

  slider.display();
}


void mouseDragged() {
  if (mouseY < height && mouseY > height*0.92) {
    slider.pressed = true;
    slider.update(mouseX);
  }
}

void mousePressed() {
  if (mouseY < height && mouseY > height*0.92) {
    slider.pressed = true;
    slider.update(mouseX);
  }
}

void mouseReleased() {
  if (slider.pressed) {
    slider.pressed = false;
  }
}
