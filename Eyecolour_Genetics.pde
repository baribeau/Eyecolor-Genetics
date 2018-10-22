// setting up global variables
int gridSize = 40; 
int pixWidth;
int[][] cellsNow, cellsNext;
float framesPerSec = 1;
int padding = 20;
color white, brown, blue, green;
boolean haveChild;

// main loop
void setup(){
  size(800,800);
  background(0);
  frameRate(framesPerSec);
  
  // give names to colours to make it friendlier to code and read
  white = color(255);
  brown = color(84,34,1); 
  blue = color(23, 89, 196); 
  green = color(12,142,12);
  
  // set size of each cell
  pixWidth = (width-2*padding)/gridSize;
  
  // prepare arrays for current cells on screen and the next generation
  cellsNow = new color[gridSize][gridSize];
  cellsNext = new color[gridSize][gridSize];
  
  setInitialCells();
  
}
    
void draw(){
  background(0);
  noStroke();
  
  // creates cells on screen from information stored in cellsNow
  for (int i=0; i<gridSize; i++){
    for (int j=0; j<gridSize; j++){
      fill(cellsNow[i][j]);
      rect(i*pixWidth+padding, j*pixWidth+padding, pixWidth, pixWidth);
      fill(0);
      rect(padding, j*pixWidth+padding, pixWidth, pixWidth);
      rect((gridSize-1)*pixWidth+padding, j*pixWidth+padding, pixWidth, pixWidth);
  
    }
  }
  
  findLove(); // finds nearby lovers for each cell
  birth(); // transfers cellsNext to cellsNow
}

void findLove(){
  for (int i=0; i<gridSize; i++){
    for (int j=0; j<gridSize; j++){
      breed(i,j); // determines eye colour probabilities
           
    }
  }
}

void breed(int i,int j){
  int brPercent, blPercent, grPercent; // the likeliness of each colour

  // for each surrounding cell
  for(int a=-1; a<=1; a++){
    for(int b=-1; b<=1; b++){
      
      try{
        // define the liklihood for each eye colour depending on the parents' eye colours
        if ((cellsNow[i+a][j+b] == brown) && (b!=0 || a!=0)){
          if (cellsNow[i][j] == brown){
            brPercent = 78;
            blPercent = 16;
            grPercent = 6;
            haveChild = true;
          }
          else if (cellsNow[i][j] == blue){
            brPercent = 72;
            blPercent = 28;
            grPercent = 0;
            haveChild = true;
          }
          else if (cellsNow[i][j] == green){
            brPercent = 60;
            blPercent = 7;
            grPercent = 33;
            haveChild = true;
          }
          else{
            brPercent = 0;
            blPercent = 0;
            grPercent = 0;
            haveChild = false;
          }
            
        }
          
        else if ((cellsNow[i+a][j+b] == blue) && (b!=0 || a!=0)){
          if (cellsNow[i][j] == brown){
            brPercent = 72;
            blPercent = 28;
            grPercent = 0;
            haveChild = true;
          }
          else if (cellsNow[i][j] == blue){
            brPercent = 1;
            blPercent = 98;
            grPercent = 1;
            haveChild = true;
          }
          else if (cellsNow[i][j] == green){
            brPercent = 0;
            blPercent = 50;
            grPercent = 50;
            haveChild = true;
          }
          else{
            brPercent = 0;
            blPercent = 0;
            grPercent = 0;
            haveChild = false;
          }
        }
          
        else if ((cellsNow[i+a][j+b] == green) && (b!=0 || a!=0)){
          if (cellsNow[i][j] == brown){
            brPercent = 60;
            blPercent = 7;
            grPercent = 33;
            haveChild = true;
          }
          else if (cellsNow[i][j] == blue){
            brPercent = 0;
            blPercent = 50;
            grPercent = 50;
            haveChild = true;
          }
          else if (cellsNow[i][j] == green){
            brPercent = 0;
            blPercent = 25;
            grPercent = 75;
            haveChild = true;
          }
          else{
            brPercent = 0;
            blPercent = 0;
            grPercent = 0;
            haveChild = false;
          }
        }
          
        else{
          brPercent = 0;
          blPercent = 0;
          grPercent = 0;
          haveChild = false;
        }
      cellsNext[i][j] = white; // all cells from the previous generation die
      findChildColour(brPercent, blPercent, grPercent, i, j); //finds the child's eye colour          
      
      }
      catch(IndexOutOfBoundsException e){}
    }
  }
  
}

// transfers the next generation to the current generation
void birth(){
  for(int i=0; i<gridSize-1; i++){
    for(int j=0; j<gridSize; j++)      
      cellsNow[i+1][j] = cellsNext[i][j];

  }
  
}

void findChildColour(int br, int bl, int gr, int i, int j){
  // make an array with the right number of each colour to randomly choose from 
  color[] a = new color[100];
  for (int k=0; k<100; k++){
    if (k<br)
      a[k] = brown;
    else if (k<br+bl)
      a[k] = blue;
    else if (k<br+bl+gr)
      a[k] = green;
  }
  
  if (haveChild){ // if a child is going to be born
    int p = round(random(-2,2)); // the kid will be placed within a 5x5 square of the parent
    int q = round(random(-2,2));
    int r = round(random(0,100)); // picking a random index for a
    try{
    cellsNext[i+p][j+q] = a[r]; 
    }
    catch(IndexOutOfBoundsException e){}
    
  }  
}


void setInitialCells(){ // based on current eye colour statistics
  for (int i=0; i<gridSize; i++){
    for (int j=0; j<gridSize; j++){
      int r = round(random(0,100));
      if(r<70)
        cellsNow[i][j] = white;
      else if(r<90)
        cellsNow[i][j] = brown;
      else if(r<98)
        cellsNow[i][j] = blue;
      else
        cellsNow[i][j] = green;
    }
  }  
}