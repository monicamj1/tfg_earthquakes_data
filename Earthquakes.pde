Table table;
String year, country;
float lat, lon, depth, mag, maxMag, minMag, a, b;
color orange, red, c;
PShape map;


void setup() {
  size (720,480);
  //fullScreen();

  map = loadShape("map.svg");

  shape(map, 0, 0, width, height); 

  red = color(255, 102, 102);
  orange = color(255, 204, 102);

  table = loadTable("database", "header, tsv"); 

  float[] magArray = new float[table.getRowCount()];


  for (int i=0; i<magArray.length; i++) {
    TableRow row = table.getRow(i);
    magArray[i] = row.getFloat("EQ_PRIMARY");
  }

  maxMag = max(magArray);
  minMag = min(magArray);
}


void draw() {

  for (TableRow row : table.findRows("2010", "YEAR")) {
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
}
