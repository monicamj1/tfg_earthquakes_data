Table table;
String year, country;
float lat, lon, depth, mag, maxMag, minMag;
color orange, red, c;

void setup() {
  size (720, 480);

  table = loadTable("database", "header, tsv"); 

  float[] magArray = new float[table.getRowCount()];


  for (int i=0; i<magArray.length; i++) {
    TableRow row = table.getRow(i);
    magArray[i] = row.getFloat("EQ_PRIMARY");
  }

  maxMag = max(magArray);
  minMag = min(magArray);

  red = color(255, 102, 102);
  orange = color(255, 240, 102);
}


void draw() {

  for (TableRow row : table.findRows("2019", "YEAR")) {

    lat = map(row.getFloat("LATITUDE"), -90, 90, height, 0);
    lon = map(row.getFloat("LONGITUDE"), -180, 180, 0, width);

    depth = row.getInt("FOCAL_DEPTH");
    float r = map(depth, 0, 700, 10, 2);

    mag = row.getFloat("EQ_PRIMARY");

    ellipseMode(RADIUS);
    noStroke(); 


    float interpolation = mag*0.13-0.213;
    c = lerpColor(orange, red, interpolation);

    fill(c); 
    ellipse(lon, lat, r, r);
    println(mag);
  }
}





/*
void draw(){
 //translate(width/2,height/2);
 //shape(map, 0,0, width, height);
 image(img, 0, 0, width, height);
 
 
 for (TableRow row : table.rows()) {
 if(row.getInt("YEAR") == 2019){
 lat = map(row.getFloat("LATITUDE"), -90, 90, height, 0);
 lon = map(row.getFloat("LONGITUDE"), -180, 180, 0, width);
 
 
 depth = row.getInt("FOCAL_DEPTH");
 float m = map(depth, 0, 700, 5, 20);
 noStroke();
 ellipseMode(RADIUS);
 fill(255,106,102);
 ellipse(lon, lat, m, m);
 }
 }
 
 }
 size (1920, 1080); //screen size
 
 println(table.getRowCount() + " total de filas");
 
 for (TableRow row : table.rows()) {
 
 year = row.getString("YEAR");
 country = row.getString("COUNTRY");
 
 println(country + ", " + year + ", " + lat +"," + lon + ", magnitude " + mag );
 }
 */
