//database
Table table;

//map
PShape map;

//slider
Slider slider;
IntList yearList;
int actualYear, newYear;

//earthquales bubbles
ArrayList<Bubble> bubbles;
float  maxMag, minMag;

//second screen
boolean showDetails;
Details details;


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

  //initialize bubbles array with Bubble objects
  bubbles = new ArrayList<Bubble>();

  //add bubble object to bubbles array
  loadEarthquakes();

  showDetails = false;
}


void draw() {
  shape(map, 0, 0, width, height);

  for (Bubble bubble : bubbles) {
    bubble.display(maxMag, minMag, showDetails);
  }

  slider.display();

  if (showDetails) {
    details.display();
  }

  //Change cursor
  changeCursor();
}


void mouseDragged() {
  if (showDetails == false) {
    if (mouseY < height && mouseY > height*0.92) {
      slider.pressed = true;
      slider.update(mouseX);
    }
    if (slider.pressed == true) {
      slider.update(mouseX);
    } else {
      showDetails = false;
    }
  }
}


void mousePressed() {
  if (showDetails == false) {
    if (mouseY < height && mouseY > height*0.92) {
      slider.pressed = true;
      slider.update(mouseX);
    } else {
      earthquakesList(1); //sends int!
    }
  } else {
    earthquakesList(1);
    showDetails = false;

    //FADE OUT: Delete previous line and add this
    //details.close = false;
  }
}

void mouseReleased() {
  if (slider.pressed) {
    slider.pressed = false;
  }
}


void changeCursor() {
  if (showDetails == false) {
    if (mouseY < height && mouseY > height*0.92) {
      cursor(HAND);
    } else if (slider.pressed == true) {
      cursor(HAND);
    }else{
      cursor(ARROW); 
      earthquakesList(0); //Sends int!
    }
  }
}

//load new earthquakes(Bubble objects) to the array
void loadEarthquakes() {
  for (TableRow row : table.findRows(str(yearList.get(slider.selected)), "YEAR")) {
    bubbles.add(new Bubble(row));
  }
}

//remove all earthquakes (Bubble objects) from the array
void removeEarthquakes() {
  for (int i = bubbles.size()-1; i>=0; i--) {
    bubbles.remove(i);
  }
}

//check if is the bubble is clicked
void earthquakesList(int c) { //receives int
  for (Bubble bubble : bubbles) {
    bubble.isClicked(c); //sends int
    if (bubble.selected && showDetails == false) {
      showDetails = true;
      TableRow row = table.findRow(str(bubble.id), "I_D");
      details = new Details(row, bubble.c);
    } else {
      bubble.noClicked();
    }
  }
}
