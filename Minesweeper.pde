import de.bezier.guido.*;
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>();

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton [NUM_ROWS][NUM_COLS];
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c = 0; c<NUM_COLS; c++) {
      buttons[r][c]= new MSButton(r, c);
    }
  }


  setMines();
}
public void setMines()
{
  int numMines = (NUM_ROWS+NUM_COLS);
  for (int i = 0; i<numMines; i++) {
    int d = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[d][c]))
      mines.add(buttons[d][c]);
    else i--;
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  for(int r=0; r<NUM_ROWS; r++){
    for(int c = 0; c<NUM_COLS; c++){
      if(!buttons[r][c].isClicked()&& !mines.contains(buttons[r][c])){
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  for(int r = 0; r<NUM_ROWS; r++){
    for(int c = 0; c<NUM_COLS; c++){
      buttons[r][c].setLabel("Lost");
    }
  }
}
public void displayWinningMessage()
{
  for(int r = 0; r<NUM_ROWS; r++){
    for(int c = 0; c<NUM_COLS; c++){
      buttons[r][c].setLabel("Win");
    }
  }
}
public boolean isValid(int r, int c)
{
  if (r<NUM_ROWS && r>-1 && c<NUM_COLS && c>-1) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r<row+2; r++)
    for (int c = col-1; c<col+2; c++)
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        numMines++;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      flagged =!flagged;
      if (flagged == false) {
       flagged = clicked = false;
      }
    } else if (mines.contains(this)) {//buttons[myRow][myCol])) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol)>0) {
      setLabel(""+countMines(myRow, myCol));
    } else 
    for (int r = myRow-1; r<=myRow+1; r++) {
      for (int c = myCol-1; c<=myCol+1; c++) {
        if (isValid(r, c)&&!buttons[r][c].isClicked())
          buttons[r][c].mousePressed();
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked()
  {
    return clicked;
  }
}
