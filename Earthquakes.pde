Table table;
float  maxMag, minMag;
PShape map;
Slider slider;
IntList yearList;
int actualYear, newYear;

//earthquakes bubbles array
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();

boolean details;


void setup() {
  //size (720, 480);
  fullScreen();

  map = loadShape("map.svg");

  table = loadTable("database", "header, tsv"); 

  float[] magArray = new float[table.getRowCount()];

  yearList = new IntList();

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

  //add bubble object to bubbles array
  loadEarthquakes();

  details = false;
}


void draw() {

  shape(map, 0, 0, width, height); 

  //display each bubble from the array
  for (Bubble bubble : bubbles) {
    bubble.display(maxMag, minMag);
  }

  slider.display();
}


void mouseDragged() {
  if (mouseY < height && mouseY > height*0.92) {
    slider.pressed = true;
    slider.update(mouseX);
  }
  if (slider.pressed == true) {
    slider.update(mouseX);
  }
}


void mousePressed() {
  if (mouseY < height && mouseY > height*0.92) {
    slider.pressed = true;
    slider.update(mouseX);
  }
  earthquakesList();
}


void mouseReleased() {
  if (slider.pressed) {
    slider.pressed = false;
  }
}

//load new earthquakes(Bubble objects) to the array
void loadEarthquakes() {
  for (TableRow row : table.findRows(str(yearList.get(slider.selected)), "YEAR")) {
    bubbles.add(new Bubble(row));
  }
}

//remove all earthquales (Bubble objects) from the array
void removeEarthquakes() {
  for (int i = bubbles.size()-1; i>=0; i--) {
    bubbles.remove(i);
  }
}

//check if is the bubble is clicked
void earthquakesList() {
  for (Bubble bubble : bubbles) {
    bubble.isClicked();
  }
}
