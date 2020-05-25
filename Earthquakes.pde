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

//zooming
float scaleValue = 1;
float transX = 0;
float transY = 0;
float factor = 1;
boolean canZoom = true, canMove = false;
int zoomCounter = 0;
float maxOX, maxX, maxOY, maxY, x, y;


void setup() {
  //size (720, 480);
  fullScreen();
  
  //set screen limits
  maxOX = 0;
  x = width;
  maxOY = 0;
  y = height;

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
  
  //zooming
  pushMatrix();
  
  if (canMove && !slider.pressed) {
    transX = transX+mouseX-pmouseX;
    transY = transY+mouseY-pmouseY;
    updateBubbles(2,0);
    limitTranslate();
  }
  
  translate(transX, transY);
  scale(scaleValue);
  
  shape(map, 0, 0, width, height);

  for (Bubble bubble : bubbles) {
    bubble.display(maxMag, minMag, showDetails);
  }
  
  popMatrix();
  //stop zooming

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
    canMove = true;
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
  canMove = false;
}

void mouseWheel(MouseEvent e) {
  if (!showDetails) {
    if (e.getCount() > 0) { //if zoom in
      factor = 1.1;
      scaleValue *= factor; //scale value increases
      if (scaleValue >= pow(1.1, 20)) { //if scale value is over limit
        zoomCounter = 20; //limit counter
        scaleValue = pow(1.1, 20); //limit scale value
        updateBubbles(0,0); //update bubbles radius
      } else {
        zoomCounter++; //zoom counter increases
        transX -= mouseX; //translate
        transY -= mouseY;
        transX *=factor;
        transY *=factor;
        transX += mouseX;
        transY += mouseY;
        x *= factor;
        y *= factor;
        updateBubbles(0,0); //update bubbles radius
      }
    } else if (e.getCount() < 0) {
      factor = 1/1.1;
      scaleValue *= factor;
      if (scaleValue <= 1) {
        zoomCounter = 0;
        scaleValue = 1;
        transX=0;
        transY=0;
        x = width;
        y = height;
        updateBubbles(0,0);
      } else {
        zoomCounter--;
        transX -= mouseX;
        transY -= mouseY;
        transX *=factor;
        transY *=factor;
        transX += mouseX;
        transY += mouseY; 
        x *= factor;
        y *= factor;
        updateBubbles(0,0);
      }
    }
    limitTranslate();
  }
}

void limitTranslate() {

  if (transX >= maxOX) {
    transX = maxOX;
    updateBubbles(1, 1);
  }
  if (transY >= maxOY) {
    transY = maxOY;
    updateBubbles(1, 2);
  }
  maxX = x - width;
  maxX = -maxX;
  if (transX <= maxX) {
    transX = maxX;
    updateBubbles(1, 3);
  }
  maxY = y - height;
  maxY = -maxY;
  if (transY <= maxY) {
    transY = maxY;
    updateBubbles(1, 4);
  }
  
}

void updateBubbles(int k, int l) {
  for (Bubble bubble : bubbles) {
    if(k==0){
      bubble.changeRadius(factor, scaleValue);
    }
    if(k==1){
      bubble.limitLonLat(l, zoomCounter);
    }
    if(k==2){
      bubble.changeActualPos();
    }
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
